# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Region < Base
      def content
        if search_terms.empty?
          subregions = Data.all_subregions
          Format.subregions(subregions)
        else
          search_terms.map do |term|
            region = Data.region(term)
  
            if region
              Format.region(region)
            else
              Atlasq.failed!
              "Unknown region: #{term}"
            end
          end.join("\n\n")
        end
      end
    end
  end
end
