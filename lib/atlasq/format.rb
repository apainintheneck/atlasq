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
        "*#{" *" * ((title.size / 2) + 2)}"
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
        *elements
      ].join("\n")
    end

    # @param country_codes [Array<String>] ISO3166 2 letter country codes
    # @param title [String]
    # @return [String]
    def self.countries(country_codes, title:)
      Format.brief_template(
        title: title,
        elements: country_codes.map do |country|
          Format.one_line_country(country)
        end
      )
    end

    # @param country_code [String] ISO3166 2 letter country code
    # @return [String]
    def self.country(country_code)
      [
        Format.country_title(country_code),
        Format.one_line_country(country_code),
        Format.multiline_country(country_code)
      ].join("\n")
    end

    # @param country_code [String] ISO3166 2 letter country code
    # @return [String]
    def self.country_title(country_code)
      Cache
        .get("formatted_output/country_title.json")
        .fetch(country_code)
        .then(&Format.method(:title))
    end

    # @param country_code [String] ISO3166 2 letter country code
    # @return [String]
    def self.one_line_country(country_code)
      Cache
        .get("formatted_output/one_line_country.json")
        .fetch(country_code)
    end

    # @param country_code [String] ISO3166 2 letter country code
    # @return [String]
    def self.multiline_country(country_code)
      Cache
        .get("formatted_output/multiline_country.json")
        .fetch(country_code)
    end

    # @param subregions [Hash<String, Array<String>>] region name to ISO3166 2 letter country codes
    # @return [String]
    def self.subregions(subregions)
      subregions = subregions.to_h do |region, countries|
        [
          Util::String.titleize(region),
          countries.map(&Format.method(:one_line_country))
        ]
      end

      Format.brief_template(title: "All Subregions", elements: subregions)
    end

    # @param currencies [Hash<String, Array<String>>] 3 letter currency code to ISO3166 2 letter country codes
    # @param partial_match [Boolean] defaults to false
    # @return [String]
    def self.currencies(currencies, partial_match: false)
      currencies = currencies.to_h do |currency, countries|
        [
          Format.one_line_currency(currency),
          countries.map(&Format.method(:one_line_country))
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

    # @param currency_code [String]
    # @return [String]
    def self.one_line_currency(currency_code)
      Cache
        .get("formatted_output/one_line_currency.json")
        .fetch(currency_code)
    end

    # @param languages [Hash<String, Array<String>>] 2 letter ISO639 language code to ISO3166 2 letter country codes
    # @param partial_match [Boolean] defaults to false
    # @return [String]
    def self.languages(languages, partial_match: false)
      languages = languages.to_h do |language, countries|
        [
          Format.one_line_language(language),
          countries.map(&Format.method(:one_line_country))
        ]
      end

      if !partial_match && languages.size == 1
        title, elements = languages.first
        title = "Language: #{title}"
        Format.brief_template(title: title, elements: elements)
      else
        title = partial_match ? "Languages (Partial Match)" : "Languages"
        Format.brief_template(title: title, elements: languages)
      end
    end

    # @param language [String] 2 letter ISO639 language code
    # @return [String]
    def self.one_line_language(language)
      Cache
        .get("formatted_output/one_line_language.json")
        .fetch(language)
    end
  end
end
