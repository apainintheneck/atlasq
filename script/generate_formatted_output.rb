# frozen_string_literal: true

require "atlasq"

require_relative "shared/cache_generator"
require_relative "shared/country_info"

# --- Helpers ---

# @param country [ISO3166::Country|Hash]
# @return [String]
def one_line_country(country)
  [
    country.emoji_flag,
    country.number,
    country.alpha2,
    country.alpha3,
    country.iso_short_name,
  ].compact
    .join(" | ")
    .then { |country_string| "(#{country_string})" }
end

# @example "English / Shona / Ndebele, North; North Ndebele"
# @param language_codes [Array<String>] Ex. ["id"]
# @return [String]
def languages(language_codes)
  language_codes
    .take(4) # arbitrary limit to avoid long lines
    .map do |lang|
      ISO_639.find(lang).english_name
    end
    .join(" / ")
end

# --- Load Cache ---

cache = CacheGenerator.new(namespace: "formatted_output")

cache.add "one_line_country" do
  ALL_COUNTRIES.to_h do |country|
    [
      country.alpha2.downcase,
      one_line_country(country),
    ]
  end
end

cache.add "country_title" do
  ALL_COUNTRIES.to_h do |country|
    [
      country.alpha2.downcase,
      "Country: #{country.iso_long_name}",
    ]
  end
end

cache.add "multiline_country" do
  ALL_COUNTRIES.to_h do |country|
    country_info = {
      "Languages" => languages(country.languages),
      "Nationality" => country.nationality,
      "Region" => country.subregion,
      "Continent" => country.continent,
      "Currency" => "#{country.currency.symbol} #{country.currency.name}",
    }.reject do |_, value|
      # "countries" like Antarctica can have missing language, nationality,
      # and region data so we remove that missing data beforehand.
      value.nil? || value.empty?
    end

    info_ladder = country_info.map.with_index do |(name, value), index|
      "#{" " * (index + 1)}| #{name}: #{value}"
    end
    info_ladder << "#{" " * (info_ladder.size + 1)}|#{"_" * 40}"

    [
      country.alpha2.downcase,
      info_ladder.join("\n"),
    ]
  end
end

cache.add "one_line_currency" do
  ALL_CURRENCIES.to_h do |currency|
    [
      currency.iso_code.downcase,
      "[#{currency.iso_code}] #{currency.symbol} #{currency.name}",
    ]
  end
end

cache.add "one_line_language" do
  ALL_LANGUAGES.to_h do |language|
    [
      language.alpha2,
      "(#{language.alpha2}/#{language.alpha3}) #{language.english_name}",
    ]
  end
end

# --- Run ---

case ARGV.first
when "generate"
  cache.generate
when "outdated"
  cache.outdated
else
  warn "Error: Expected a valid subcommand: generate or outdated"
  exit 1
end
