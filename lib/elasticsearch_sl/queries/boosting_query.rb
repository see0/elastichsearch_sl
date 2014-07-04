module ElasticsearchSl
  module Queries
    class BoostingQuery
      attr_reader :data

      def initialize(data = nil, options={}, &block)
        @data = data
        @options = options
        @value   = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def positive(&block)
        (@value[:positive] ||= []) << Query.new(@data, &block).to_hash
        @value
      end

      def negative(&block)
        (@value[:negative] ||= []) << Query.new(@data, &block).to_hash
        @value
      end

      def to_hash
        @value.update(@options)
      end
    end

  end
end