module ElasticsearchSl
  module Shared
    class Boolean

      # TODO: Try to get rid of multiple `should`, `must`, etc invocations, and wrap queries directly:
      #
      #       boolean do
      #         should do
      #           string 'foo'
      #           string 'bar'
      #         end
      #       end
      #
      # Inherit from Query, implement `encode` method there, and overload it here, so it puts
      # queries in an Array instead of hash.

      def initialize(type, data= nil, options={}, &block)
        @data = data
        @type = type
        @options = options
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def must(&block)
        (@value[:must] ||= []) << @type.new(@data, &block).to_hash
        @value
      end

      def must_not(&block)
        (@value[:must_not] ||= []) << @type.new(@data, &block).to_hash
        @value
      end

      def should(&block)
        (@value[:should] ||= []) << @type.new(@data, &block).to_hash
        @value
      end

      def to_hash
        @value.update(@options)
      end

    end
  end
end