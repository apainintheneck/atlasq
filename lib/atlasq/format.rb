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
        "*#{" *" * ((title.size / 2) + 2)}",
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
    # @param elements [Array<String>, Hash<String, Array<String>>]
    # @return [String]
    def self.brief_template(title:, elements:)
      elements =
        case elements
        when Array
          elements.sort
        when Hash
          elements
            .sort_by(&:first)
            .each_with_object([]) do |(key, values), array|
              array << "- #{key}"
              values.sort.each { |value| array << "    #{value}" }
            end
        else
          raise Error, "Unknown elements type: #{elements.class}"
        end

      [
        Format.title(title),
        *elements,
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
        *info_ladder,
      ].join("\n")
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
          "Languages" => Format.languages(country.languages),
          "Nationality" => country.nationality,
          "Region" => country.subregion,
          "Continent" => country.continent,
          "Currency" => "#{country.currency.symbol} #{country.currency.name}",
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
    def self.languages(language_codes)
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
          country.emoji_flag,
          country.number,
          country.alpha2,
          country.alpha3,
          country.iso_short_name,
        ]
      when Hash
        values = country.slice(
          "number",
          "alpha2",
          "alpha3",
          "iso_short_name"
        ).values

        [
          Data.emoji_flag(country.fetch("number")),
          *values,
        ]
      else
        raise Error, "Unknown country type: #{country.class}"
      end.then do |country_values|
        "(#{country_values.compact.join(" | ")})"
      end
    end

    # @param subregions [Hash<String, Array<ISO3166::Country>>]
    # @return [String]
    def self.subregions(subregions)
      subregions.transform_values! do |countries|
        countries.map(&Format.method(:one_line_country))
      end

      Format.brief_template(title: "All Subregions", elements: subregions)
    end

    # @param currencies [Hash<Money::Currency, Array<ISO3166::Country>>]
    # @param partial_match [Boolean] defaults to false
    # @return [String]
    def self.currencies(currencies, partial_match: false)
      currencies = currencies.to_h do |currency, countries|
        [
          "[#{currency.iso_code}] #{currency.symbol} #{currency.name}",
          countries.map(&Format.method(:one_line_country)),
        ]
      end

      if !partial_match && currencies.size == 1
        title, elements = currencies.first
        title = "Currency: #{title}"
        Format.brief_template(title: title, elements: elements)
      else
        title = partial_match ? "Currencies (Partial Match)" : "Currencies"
        Format.brief_template(title: title, elements: currencies)
      end
    end
  end
end
