# Atlasq
[![Gem Version](https://badge.fury.io/rb/atlasq.svg)](https://badge.fury.io/rb/atlasq)

Query for country info at the command line.

```console
$ atlasq 
atlasq -- a utility to query country info

usage:
  atlasq query...
  atlasq [command] query...
  atlasq -h/--help
  atlasq -v/--version

commands:
  -c/--country : find countries
  -r/--region  : find countries by region
  -m/--money   : find countries by currency

```

Install the gem from RubyGems with `gem install atlasq`.

## Documentation

```console
$ atlasq --help
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
    : Display the version (0.1.0)

  -d/--debug
    : Display debug output

```

## Examples

### Countries

```console
$ atlasq --country 418
*
* Country: The Lao People's Democratic Republic
* * * * * * * * * * * * * * * * * * * * * * * * *
(🇱🇦 | 418 | LA | LAO | Lao People's Democratic Republic)
 | Search Term: 418
  | Languages: Lao
   | Nationality: Laotian
    | Region: South-Eastern Asia
     | Continent: Asia
      | Currency: ₭ Lao Kip
       |________________________________________

```

```console
$ atlasq --country AM
*
* Country: The Republic of Armenia
* * * * * * * * * * * * * * * * * * *
(🇦🇲 | 051 | AM | ARM | Armenia)
 | Search Term: AM
  | Languages: Armenian / Russian
   | Nationality: Armenian
    | Region: Western Asia
     | Continent: Asia
      | Currency: դր. Armenian Dram
       |________________________________________

```

```console
$ atlasq --country honduras
*
* Country: The Republic of Honduras
* * * * * * * * * * * * * * * * * * *
(🇭🇳 | 340 | HN | HND | Honduras)
 | Search Term: honduras
  | Languages: Spanish; Castilian
   | Nationality: Honduran
    | Region: Central America
     | Continent: North America
      | Currency: L Honduran Lempira
       |________________________________________

```

### Regions

```console
$ atlasq --region melanesia
*
* Region: Melanesia
* * * * * * * * * * *
(🇫🇯 | 242 | FJ | FJI | Fiji)
(🇳🇨 | 540 | NC | NCL | New Caledonia)
(🇵🇬 | 598 | PG | PNG | Papua New Guinea)
(🇸🇧 | 090 | SB | SLB | Solomon Islands)
(🇻🇺 | 548 | VU | VUT | Vanuatu)

```

```console
$ atlasq --region antarctica
*
* Region: Antarctica
* * * * * * * * * * * *
(🇦🇶 | 010 | AQ | ATA | Antarctica)
(🇧🇻 | 074 | BV | BVT | Bouvet Island)
(🇬🇸 | 239 | GS | SGS | South Georgia and the South Sandwich Islands)
(🇭🇲 | 334 | HM | HMD | Heard Island and McDonald Islands)

```

### Currencies

```console
$ atlasq --money ANG
*
* Currency: [ANG] ƒ Netherlands Antillean Gulden
* * * * * * * * * * * * * * * * * * * * * * * * * *
(🇨🇼 | 531 | CW | CUW | Curaçao)
(🇸🇽 | 534 | SX | SXM | Sint Maarten (Dutch part))

```

```console
$ atlasq --money \฿
*
* Currencies (Partial Match)
* * * * * * * * * * * * * * * *
- [THB] ฿ Thai Baht
    (🇹🇭 | 764 | TH | THA | Thailand)

```

```console
$ atlasq --money Surinamese\ Dollar
*
* Currency: [SRD] $ Surinamese Dollar
* * * * * * * * * * * * * * * * * * * *
(🇸🇷 | 740 | SR | SUR | Suriname)

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
