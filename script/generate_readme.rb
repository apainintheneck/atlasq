# frozen_string_literal: true

require "shellwords"

EXECUTABLE_PATH = File.expand_path("../exe/atlasq", __dir__).freeze

def atlasq(*args)
  escaped_args = args
    .map(&Shellwords.method(:escape))
    .join(" ")

  [
    "$ atlasq #{escaped_args}",
    `#{EXECUTABLE_PATH} #{escaped_args}`,
  ].join("\n")
end

puts <<~README
  # Atlasq
  [![Gem Version](https://badge.fury.io/rb/atlasq.svg)](https://badge.fury.io/rb/atlasq)

  Query for country info at the command line.

  ```console
  #{atlasq}
  ```

  Install the gem from RubyGems with `gem install atlasq`.

  ## Documentation

  ```console
  #{atlasq "--help"}
  ```

  ## Examples

  ### Countries

  ```console
  #{atlasq "--country", "418"}
  ```

  ```console
  #{atlasq "--country", "AM"}
  ```

  ```console
  #{atlasq "--country", "honduras"}
  ```

  ### Regions

  ```console
  #{atlasq "--region", "melanesia"}
  ```

  ```console
  #{atlasq "--region", "antarctica"}
  ```

  ### Currencies

  ```console
  #{atlasq "--money", "ANG"}
  ```

  ```console
  #{atlasq "--money", "฿"}
  ```

  ```console
  #{atlasq "--money", "Surinamese Dollar"}
  ```

  ## Data

  Country data is sourced from the [countries](https://github.com/countries/countries) gem which provides country and region information and implements the ISO3166 standard country codes and names.

  Currency data is sourced from the [money](https://github.com/RubyMoney/money) gem which provides information about currency names and symbols.

  Language data is sourced from the [ISO-639](https://github.com/xwmx/iso-639) gem which implements the ISO369 standard for language codes and names.

  ## Development

  After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. Use either `rake lint` to lint the code or `rake fix` to automatically fix simple linter errors.

  You can also run `bin/console` for an interactive prompt that will allow you to experiment.

  To install this gem onto your local machine, run `bundle exec rake install`.

  This file gets generated with the `rake readme:generate` command to make sure the example output is always up-to-date. We even check for this on CI with the `rake readme:outdated` command.

  More information about cached files can be found in `cache/README.md`.

  ## Contributing

  Bug reports and pull requests are welcome on GitHub at https://github.com/apainintheneck/atlasq.

  ## License

  The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
README
