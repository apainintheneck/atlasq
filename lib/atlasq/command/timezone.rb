# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Timezone < Base
      def content
        if search_terms.empty?
          timezones = Data.all_timezones
          Format.timezones(timezones)
        else
          search_terms.map do |term|
            timezones = Data.timezones(term)

            if timezones.empty?
              Atlasq.failed!
              "Unknown timezone: #{term}"
            else
              Format.timezones(timezones)
            end
          end.join("\n\n")
        end
      end
    end
  end
end
