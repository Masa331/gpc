module Gpc
  module Refinements
    refine String do
      def sections(secs = {})
        parts = {}
        str = self.dup

        secs.each do |name, length|
          parts[name] = str.slice!(0, length)
        end

        parts
      end

      def remove_leading_zeroes
        gsub(/\A0*/, '')
      end

      def remove_leading_zeroes!
        gsub!(/\A0*/, '')
      end
    end
  end
end
