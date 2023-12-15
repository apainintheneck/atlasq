# frozen_string_literal: true

require "atlasq"

require_relative "shared/cache_generator"

# --- Data ---

require "countries"
require "iso-639"
require "money"
require "money-heuristics"

ISO3166.configure do |config|
  # Needed to allow us to access the `ISO3166::Country#currency`
  # object which ends up being an instance of `Money::Currency`.
  config.enable_currency_extension!

  # Needed to allow us to search by localized country name.
  config.locales = %i[
    af am ar as az be bg bn br bs
    ca cs cy da de dz el en eo es
    et eu fa fi fo fr ga gl gu he
    hi hr hu hy ia id is it ja ka
    kk km kn ko ku lt lv mi mk ml
    mn mr ms mt nb ne nl nn oc or
    pa pl ps pt ro ru rw si sk sl
    so sq sr sv sw ta te th ti tk
    tl tr tt ug uk ve vi wa wo xh
    zh zu
  ]
end

ALL_COUNTRIES = ISO3166::Country.all.freeze
ALL_CURRENCIES = ALL_COUNTRIES.map(&:currency).uniq.freeze

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
      *country.translated_names,
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
      *country.translated_names,
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
      country.world_region,
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
      currency.name,
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
      *Atlasq::Util::String.word_split(currency.name),
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
