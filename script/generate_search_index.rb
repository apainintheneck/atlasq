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

# --- Helpers ---

require "unaccent"

def normalize(string)
  @normalize ||= {}
  @normalize[string] ||= Unaccent.unaccent(string.downcase)
end

def split(sentence)
  sentence.split(/[ \t,;:()]+/).reject(&:empty?)
end

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

    names.map! { |name| normalize(name) }
    names.uniq!

    key = country.alpha2

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
      split(name).map do |word|
        normalize(word)
      end
    end.uniq

    key = country.alpha2

    words.each do |word|
      hash[word] ||= []
      hash[word] << key
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
