# frozen_string_literal: true

module Atlasq
  module Format
    # @example
    # *
    # * Title
    # * * * * *
    #
    # @param title [String]
    # @return [String]
    def self.title(title)
      [
        "*",
        "* #{title}",
        "* #{"* " * ((title.size / 2) + 2)}"
      ].join("\n")
    end

    # @example for elements [Array<String>]
    # *
    # * Title
    # * * * * *
    # (attr1 | attr2 | attr3)
    # (attr1 | attr2 | attr3)
    # (attr1 | attr2 | attr3)
    #
    # @example for elements [Hash<String, Array<String>>]
    # *
    # * Title
    # * * * * *
    # - Heading 1.0
    #   (attr1 | attr2 | attr3)
    #   (attr1 | attr2 | attr3)
    # - Heading 2.0
    #   (attr1 | attr2 | attr3)
    #
    # @param title [String]
    # @param elements [Array<String>|Hash<String, Array<String>>]
    # @return [String]
    def self.brief_template(title:, elements:)
      if elements.is_a?(Hash)
        elements = elements
          .sort_by(&:first)
          .each_with_object([]) do |(key, values), array|
            array << "- #{key}"
            values.sort.each { |value| array << "  #{value}" }
          end
      end

      [
        Format.title(title),
        *elements
      ].join("\n")
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
    # @param attributes [String]
    # @param info [Hash<String, String>]
    # @return [String]
    def self.verbose_template(title:, attributes:, info:)
      info_ladder = info.map.with_index do |(name, value), index|
        "#{" " * (index + 1)}| #{name}: #{value}"
      end
      info_ladder << "#{" " * (info_ladder.size + 1)}|#{"_" * 40}"

      [
        Format.title(title),
        attributes,
        *info_ladder
      ].join("\n")
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
        title: "Country: #{country.iso_long_name}",
        attributes: Format.one_line_country(country),
        info: {
          "Search Term" => search_term,
          "Languages" => Format.language_codes(country.languages),
          "Nationality" => country.nationality,
          "Region" => country.subregion,
          "Continent" => country.continent,
          "Currency" => "#{country.currency.symbol} #{country.currency.name}"
        }.reject do |_, value|
          # "countries" like Antarctica can have missing language, nationality,
          # and region data so we remove that missing data beforehand.
          value.nil? || value.empty?
        end.to_h
      )
    end

    # @example "English / Shona / Ndebele, North; North Ndebele"
    # @param language_codes [Array<String>] Ex. ["id"]
    # @return [String]
    def self.language_codes(language_codes)
      language_codes
        .take(4) # arbitrary limit to avoid long lines
        .map do |lang|
          ISO_639.find(lang).english_name
        end
        .join(" / ")
    end

    # @param countries [Array<ISO3166::Country|Hash>]
    # @param title [String]
    # @return [String]
    def self.countries(countries, title:)
      Format.brief_template(
        title: title,
        elements: countries.map do |country|
          Format.one_line_country(country)
        end
      )
    end

    # @param country [ISO3166::Country|Hash]
    # @return [String]
    def self.one_line_country(country)
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
      end.then do |country_values|
        "(#{country_values.join(" | ")})"
      end
    end

    # @param region [Atlasq::Data::Region]
    # @return [String]
    def self.region(region)
      type = Util::String.titleize(region.type)
      title = "#{type}: #{region.name}"

      Format.countries(region.countries, title: title)
    end

    # @param subregions [Hash<String, Array<ISO3166::Country>>]
    # @return [String]
    def self.subregions(subregions)
      subregions = subregions.to_h do |subregion, countries|
        [
          subregion,
          countries.map(&Format.method(:one_line_country))
        ]
      end

      Format.brief_template(title: "All Subregions", elements: subregions)
    end
  end
end
