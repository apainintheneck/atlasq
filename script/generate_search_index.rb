# frozen_string_literal: true

require "atlasq"

require_relative "shared/cache_generator"
require_relative "shared/country_info"

# --- Load Cache ---

cache = CacheGenerator.new(namespace: "search_index")

cache.add "direct_match_country" do
  ALL_COUNTRIES.each_with_object({}) do |country, hash|
    names = [
      country.alpha2,
      country.alpha3,
      country.number,
      country.iso_short_name,
      country.iso_long_name,
      *country.unofficial_names,
      *country.translated_names
    ]
    names.map! { |name| Atlasq::Util::String.normalize(name) }
    names.uniq!

    key = country.alpha2.downcase

    names.each do |name|
      hash[name] = key
    end
  end
end

cache.add "partial_match_country" do
  ALL_COUNTRIES.each_with_object({}) do |country, hash|
    names = [
      country.iso_short_name,
      country.iso_long_name,
      *country.unofficial_names,
      *country.translated_names
    ]

    words = names.flat_map do |name|
      Atlasq::Util::String.word_split(name).map do |word|
        Atlasq::Util::String.normalize(word)
      end
    end.uniq

    key = country.alpha2.downcase

    words.each do |word|
      hash[word] ||= []
      hash[word] << key
    end
  end
end

cache.add "countries_by_region" do
  ALL_COUNTRIES.each_with_object({}) do |country, hash|
    names = [
      country.region,
      country.subregion,
      country.continent,
      country.world_region
    ]
    names.map! { |name| Atlasq::Util::String.normalize(name) }
    names.uniq!
    names.reject!(&:empty?)

    key = country.alpha2.downcase

    names.each do |name|
      hash[name] ||= []
      hash[name] << key
    end
  end
end

cache.add "direct_match_currency" do
  ALL_CURRENCIES.each_with_object({}) do |currency, hash|
    names = [
      currency.iso_numeric,
      currency.iso_code,
      currency.name
    ]
    names.map! { |name| Atlasq::Util::String.normalize(name) }
    names.uniq!

    key = currency.iso_code.downcase
    names.each do |name|
      hash[name] = key
    end
  end
end

cache.add "partial_match_currency" do
  ALL_CURRENCIES.each_with_object({}) do |currency, hash|
    words = [
      currency.iso_numeric,
      currency.iso_code,
      currency.symbol,
      *Atlasq::Util::String.word_split(currency.name)
    ]
    words.map! { |word| Atlasq::Util::String.normalize(word) }
    words.uniq!

    key = currency.iso_code.downcase
    words.each do |word|
      hash[word] ||= []
      hash[word] << key
    end
  end
end

cache.add "countries_by_currency" do
  ALL_COUNTRIES.each_with_object({}) do |country, hash|
    currency_code = country.currency.iso_code.downcase
    hash[currency_code] ||= []
    hash[currency_code] << country.alpha2.downcase
  end
end

cache.add "direct_match_language" do
  ALL_LANGUAGES.each_with_object({}) do |language, hash|
    key = language.alpha3.downcase
    hash[language.alpha2.downcase] = key unless language.alpha2.empty?
    hash[language.alpha3.downcase] = key
  end
end

cache.add "partial_match_language" do
  ALL_LANGUAGES.each_with_object({}) do |language, hash|
    names = [
      language.english_name,
      language.french_name
    ]

    words = names.flat_map do |name|
      Atlasq::Util::String.word_split(name).map do |word|
        Atlasq::Util::String.normalize(word)
      end
    end.uniq

    key = language.alpha3.downcase
    words.each do |word|
      hash[word] ||= []
      hash[word] << key
    end
  end
end

cache.add "countries_by_language" do
  countries_by_language = ALL_LANGUAGES.to_h do |language|
    [language.alpha3, []]
  end

  ALL_COUNTRIES.each_with_object(countries_by_language) do |country, hash|
    country.languages.map(&:downcase).each do |language_code|
      language = ISO_639.find(language_code)
      hash[language.alpha3] << country.alpha2.downcase
    end
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
