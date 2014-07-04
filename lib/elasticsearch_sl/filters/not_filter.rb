module ElasticsearchSl
  module Filters
    class NotFilter
      attr_reader :data

      def initialize(data= nil, options={}, &block)
        @data = data
        @options = options
        @value   = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def filter(&block)
        @value = {not: {filter: {}}}
        @value[:not][:filter] = Filter.new(@data, &block).to_hash
        @value
      end

      def to_hash
        @value.update(@options)
      end

      def to_json(options={})
        to_hash.to_json
      end

    end
  end
end