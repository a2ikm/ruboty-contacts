module Ruboty
  module Contacts
    class Contact
      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes.stringify_keys
      end

      def to_hash
        attributes
      end

      def description
        %<%s: %s> % [name, number]
      end

      def name
        attributes["name"]
      end

      def number
        attributes["number"]
      end
    end
  end
end
