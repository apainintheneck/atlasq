# frozen_string_literal: true

require "countries"
require "iso-639"
require "money"

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
