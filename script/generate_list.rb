# frozen_string_literal: true

require "atlasq"

require_relative "shared/cache_generator"
require_relative "shared/country_info"

# --- Load Cache ---

cache = CacheGenerator.new(namespace: "list")

cache.add "all_countries" do
  ALL_COUNTRIES.map { |country| country.alpha2.downcase }
end

cache.add "all_subregions" do
  ALL_COUNTRIES
    .map { |country| country.subregion.downcase }
    .uniq
    .sort
    .tap do |subregions|
      # Multiple countries do not have a valid subregion so shouldn't be shown.
      # (010 | AQ | ATA | Antarctica)
      # (074 | BV | BVT | Bouvet Island)
      # (334 | HM | HMD | Heard Island and McDonald Islands)
      subregions.delete("")
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
