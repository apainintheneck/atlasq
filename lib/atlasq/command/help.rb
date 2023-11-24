# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Help < Base
      # @return [String]
      def content
        <<~HELP
          NAME
            atlasq -- a utility to query country info

          SYNOPSIS:
            atlasq [query ...]
            atlasq [option]
            atlasq [option] [query ...]

          DESCRIPTIONS
            Atlas Query aims to be the the simplest way to query for country
            info at the command line. It includes logic to not only find
            countries by name but also by region and currency.

            To do this we take advantage of a myriad of different ISO standards:
              - ISO3166 : Alpha and numeric codes for countries and subdivisions
              - ISO4217 : Alpha and numeric codes for currencies
              - ISO639  : Alpha and numeric codes for languages

          OPTIONS
            [none]
              : Search for countries by the following criteria
                1. country  (like --country)
                2. region   (like --region)
                3. currency (like --money)

            -c/--country
              : Display all countries
            -c/--country [query ...]
              : Search for countries by the following criteria
                1. alpha2 (ISO3166 standard 2 letter code)
                2. alpha3 (ISO3166 standard 3 letter code)
                3. number (ISO3166 standard 3 digit code)
                4. name   (common, localized, unofficial)
                5. partial match on name

            -r/--region
              : Display all countries by subregion
            -r/--region  [query ...]
              : Search for countries by the following criteria
                1. region
                2. subregion
                3. world region (4 letter code)
                4. continent

            -m/--money
              : Display all countries by currency
            -m/--money   [query ...]
              : Search for countries by the following criteria
                1. code   (ISO4127 standard 3 letter code)
                2. name   (ISO4127 standard name)
                3. symbol
                4. partial match on name

            -h/--help
              : Display this page

            -v/--version
              : Display the version (#{VERSION})

            -d/--debug
              : Display debug output
        HELP
      end
    end
  end
end
