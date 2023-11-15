# frozen_string_literal: true

require "test_helper"

class ShellTest < Minitest::Test
  #
  # COUNTRY
  #
  def expected_country_output(search_term)
    <<~OUTPUT
      *
      * Country: The Commonwealth of Australia
      * * * * * * * * * * * * * * * * * * * * * *
      (🇦🇺 | 036 | AU | AUS | Australia)
       | Search Term: #{search_term}
        | Languages: English
         | Nationality: Australian
          | Region: Australia and New Zealand
           | Continent: Australia
            | Currency: $ Australian Dollar
             |________________________________________
    OUTPUT
  end

  def test_country_output
    commands = %w[-c --country --countries]
    countries = %w[AU AUS 036 Australia Awstraaliya]

    commands.product(countries).each do |args|
      search_term = args.last
      actual_output, _err = capture_io do
        Atlasq::Shell.start!(args)
      end

      assert_equal expected_country_output(search_term), actual_output
    end
  end

  #
  # Region
  #
  def test_region_output
    expected_output = <<~OUTPUT
      *
      * Region: Oceania
      * * * * * * * * * *
      (🇦🇸 | 016 | AS | ASM | American Samoa)
      (🇦🇺 | 036 | AU | AUS | Australia)
      (🇨🇨 | 166 | CC | CCK | Cocos (Keeling) Islands)
      (🇨🇰 | 184 | CK | COK | Cook Islands)
      (🇨🇽 | 162 | CX | CXR | Christmas Island)
      (🇫🇯 | 242 | FJ | FJI | Fiji)
      (🇫🇲 | 583 | FM | FSM | Micronesia (Federated States of))
      (🇬🇺 | 316 | GU | GUM | Guam)
      (🇰🇮 | 296 | KI | KIR | Kiribati)
      (🇲🇭 | 584 | MH | MHL | Marshall Islands)
      (🇲🇵 | 580 | MP | MNP | Northern Mariana Islands)
      (🇳🇨 | 540 | NC | NCL | New Caledonia)
      (🇳🇫 | 574 | NF | NFK | Norfolk Island)
      (🇳🇷 | 520 | NR | NRU | Nauru)
      (🇳🇺 | 570 | NU | NIU | Niue)
      (🇳🇿 | 554 | NZ | NZL | New Zealand)
      (🇵🇫 | 258 | PF | PYF | French Polynesia)
      (🇵🇬 | 598 | PG | PNG | Papua New Guinea)
      (🇵🇳 | 612 | PN | PCN | Pitcairn)
      (🇵🇼 | 585 | PW | PLW | Palau)
      (🇸🇧 | 090 | SB | SLB | Solomon Islands)
      (🇹🇰 | 772 | TK | TKL | Tokelau)
      (🇹🇴 | 776 | TO | TON | Tonga)
      (🇹🇻 | 798 | TV | TUV | Tuvalu)
      (🇻🇺 | 548 | VU | VUT | Vanuatu)
      (🇼🇫 | 876 | WF | WLF | Wallis and Futuna)
      (🇼🇸 | 882 | WS | WSM | Samoa)
    OUTPUT

    %w[-r --region --regions].each do |command|
      actual_output, _err = capture_io do
        Atlasq::Shell.start!([command, "oceania"])
      end

      assert_equal expected_output, actual_output
    end
  end

  def test_subregion_output
    expected_output = <<~OUTPUT
      *
      * Subregion: Central Asia
      * * * * * * * * * * * * * *
      (🇰🇬 | 417 | KG | KGZ | Kyrgyzstan)
      (🇰🇿 | 398 | KZ | KAZ | Kazakhstan)
      (🇹🇯 | 762 | TJ | TJK | Tajikistan)
      (🇹🇲 | 795 | TM | TKM | Turkmenistan)
      (🇺🇿 | 860 | UZ | UZB | Uzbekistan)
    OUTPUT

    %w[-r --region --regions].each do |command|
      actual_output, _err = capture_io do
        Atlasq::Shell.start!([command, "central asia"])
      end

      assert_equal expected_output, actual_output
    end
  end

  def test_world_region_output
    expected_output = <<~OUTPUT
      *
      * World Region: AMER
      * * * * * * * * * * * *
      (🇦🇬 | 028 | AG | ATG | Antigua and Barbuda)
      (🇦🇮 | 660 | AI | AIA | Anguilla)
      (🇦🇶 | 010 | AQ | ATA | Antarctica)
      (🇦🇷 | 032 | AR | ARG | Argentina)
      (🇦🇼 | 533 | AW | ABW | Aruba)
      (🇧🇧 | 052 | BB | BRB | Barbados)
      (🇧🇲 | 060 | BM | BMU | Bermuda)
      (🇧🇴 | 068 | BO | BOL | Bolivia (Plurinational State of))
      (🇧🇷 | 076 | BR | BRA | Brazil)
      (🇧🇸 | 044 | BS | BHS | Bahamas)
      (🇧🇿 | 084 | BZ | BLZ | Belize)
      (🇨🇦 | 124 | CA | CAN | Canada)
      (🇨🇱 | 152 | CL | CHL | Chile)
      (🇨🇴 | 170 | CO | COL | Colombia)
      (🇨🇷 | 188 | CR | CRI | Costa Rica)
      (🇨🇺 | 192 | CU | CUB | Cuba)
      (🇨🇼 | 531 | CW | CUW | Curaçao)
      (🇩🇲 | 212 | DM | DMA | Dominica)
      (🇩🇴 | 214 | DO | DOM | Dominican Republic)
      (🇪🇨 | 218 | EC | ECU | Ecuador)
      (🇫🇰 | 238 | FK | FLK | Falkland Islands (Malvinas))
      (🇬🇩 | 308 | GD | GRD | Grenada)
      (🇬🇫 | 254 | GF | GUF | French Guiana)
      (🇬🇵 | 312 | GP | GLP | Guadeloupe)
      (🇬🇸 | 239 | GS | SGS | South Georgia and the South Sandwich Islands)
      (🇬🇹 | 320 | GT | GTM | Guatemala)
      (🇬🇾 | 328 | GY | GUY | Guyana)
      (🇭🇳 | 340 | HN | HND | Honduras)
      (🇭🇹 | 332 | HT | HTI | Haiti)
      (🇯🇲 | 388 | JM | JAM | Jamaica)
      (🇰🇳 | 659 | KN | KNA | Saint Kitts and Nevis)
      (🇰🇾 | 136 | KY | CYM | Cayman Islands)
      (🇱🇨 | 662 | LC | LCA | Saint Lucia)
      (🇲🇫 | 663 | MF | MAF | Saint Martin (French part))
      (🇲🇶 | 474 | MQ | MTQ | Martinique)
      (🇲🇽 | 484 | MX | MEX | Mexico)
      (🇳🇮 | 558 | NI | NIC | Nicaragua)
      (🇵🇦 | 591 | PA | PAN | Panama)
      (🇵🇪 | 604 | PE | PER | Peru)
      (🇵🇲 | 666 | PM | SPM | Saint Pierre and Miquelon)
      (🇵🇷 | 630 | PR | PRI | Puerto Rico)
      (🇵🇾 | 600 | PY | PRY | Paraguay)
      (🇸🇷 | 740 | SR | SUR | Suriname)
      (🇸🇻 | 222 | SV | SLV | El Salvador)
      (🇸🇽 | 534 | SX | SXM | Sint Maarten (Dutch part))
      (🇹🇹 | 780 | TT | TTO | Trinidad and Tobago)
      (🇺🇲 | 581 | UM | UMI | United States Minor Outlying Islands)
      (🇺🇸 | 840 | US | USA | United States of America)
      (🇺🇾 | 858 | UY | URY | Uruguay)
      (🇻🇨 | 670 | VC | VCT | Saint Vincent and the Grenadines)
      (🇻🇪 | 862 | VE | VEN | Venezuela (Bolivarian Republic of))
      (🇻🇬 | 092 | VG | VGB | Virgin Islands (British))
      (🇻🇮 | 850 | VI | VIR | Virgin Islands (U.S.))
    OUTPUT

    %w[-r --region --regions].each do |command|
      actual_output, _err = capture_io do
        Atlasq::Shell.start!([command, "AMER"])
      end

      assert_equal expected_output, actual_output
    end
  end

  def test_continent_output
    expected_output = <<~OUTPUT
      *
      * Continent: Antarctica
      * * * * * * * * * * * * *
      (🇦🇶 | 010 | AQ | ATA | Antarctica)
      (🇧🇻 | 074 | BV | BVT | Bouvet Island)
      (🇬🇸 | 239 | GS | SGS | South Georgia and the South Sandwich Islands)
      (🇭🇲 | 334 | HM | HMD | Heard Island and McDonald Islands)
    OUTPUT

    %w[-r --region --regions].each do |command|
      actual_output, _err = capture_io do
        Atlasq::Shell.start!([command, "antarctica"])
      end

      assert_equal expected_output, actual_output
    end
  end
end
