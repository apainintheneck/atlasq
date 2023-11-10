# frozen_string_literal: true

module Atlasq
  module Format
    # @example
    # *
    # * Title
    # * * * * *
    # [attr1 | attr2 | attr3]
    # | Info One: 1
    #  | Info Two: 2
    #   | Info Three: 3
    #    |________________________________________
    #
    # @param title [String]
    # @param attributes [Array<String>]
    # @param info [Hash<String,String>]
    # @return [String]
    def self.template(title:, attributes:, info:)
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

    # @param country [ISO3166::Country]
    # @return [String]
    def self.country(country, search_term)
      Format.template(
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
