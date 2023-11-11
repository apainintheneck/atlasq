# frozen_string_literal: true

module Atlasq
  module Format
    # @example
    # *
    # * Title
    # * * * * *
    # (attr1 | attr2 | attr3)
    # (attr1 | attr2 | attr3)
    # (attr1 | attr2 | attr3)
    #
    # @param title [String]
    # @param elements [Array<Array<String>>]
    # @return [String]
    def self.brief_template(title:, elements:)
      rows = []

      rows << "*"
      rows << "* #{title}"
      rows << "* #{"* " * ((title.size / 2) + 2)}"

      elements.each do |elem|
        rows << "(#{elem.join(" | ")})"
      end

      rows.join("\n")
    end

    # @example
    # *
    # * Title
    # * * * * *
    # (attr1 | attr2 | attr3)
    # | Info One: 1
    #  | Info Two: 2
    #   | Info Three: 3
    #    |________________________________________
    #
    # @param title [String]
    # @param attributes [Array<String>]
    # @param info [Hash<String, String>]
    # @return [String]
    def self.verbose_template(title:, attributes:, info:)
      info_ladder = info.map.with_index do |(name, value), index|
        "#{" " * (index + 1)}| #{name}: #{value}"
      end
      info_ladder << "#{" " * (info_ladder.size + 1)}|#{"_" * 40}"

      <<~TEMPLATE
        *
        * #{title}
        * #{"* " * ((title.size / 2) + 2)}
        (#{attributes.join(" | ")})
        #{info_ladder.join("\n")}
      TEMPLATE
    end

    # @param value
    # @param search_term [String]
    # @return [String]
    def self.any(value, search_term)
      case value
      when ISO3166::Country
        Format.country(value, search_term)
      when Atlasq::Data::Region
        Format.region(value)
      else
        raise Error, "Unknown format type: #{value.class}"
      end
    end

    # @param country [ISO3166::Country]
    # @param search_term [String]
    # @return [String]
    def self.country(country, search_term)
      Format.verbose_template(
        title: country.iso_long_name,
        attributes: [
          country.number,
          country.alpha2,
          country.alpha3,
          country.iso_short_name
        ],
        info: {
          "Search Term" => search_term,
          "Languages" => Format.language_codes(country.languages),
          "Nationality" => country.nationality,
          "Region" => country.subregion,
          "Continent" => country.continent,
          "Currency" => "#{country.currency.symbol} #{country.currency.name}"
        }
      )
    end

    # @param countries [Array<ISO3166::Country|Hash>]
    # @param title [String]
    # @return [String]
    def self.countries(countries, title:)
      Format.brief_template(
        title: title,
        elements: countries.map do |country|
          case country
          when ISO3166::Country
            [
              country.number,
              country.alpha2,
              country.alpha3,
              country.iso_short_name
            ]
          when Hash
            country.slice(
              "number",
              "alpha2",
              "alpha3",
              "iso_short_name"
            ).values
          else
            raise Error, "Unknown country type: #{country.class}"
          end
        end
      )
    end

    # @param region [Atlasq::Data::Region]
    # @return [String]
    def self.region(region)
      type = Util::String.titleize(region.type)
      title = "#{type}: #{region.name}"

      Format.countries(region.countries, title: title)
    end

    # @param language_codes [Array<String>] Ex. ["id"]
    # @return [String]
    def self.language_codes(language_codes)
      language_codes
        .take(4) # arbitrary limit to avoid long lines
        .map do |lang|
          ISO_639
            .find(lang)
            .english_name
            .split(";")
            .first
        end
        .join(", ")
    end
  end
end
