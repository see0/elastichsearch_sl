module ElasticsearchSl
  module Queries
    class FunctionScoreQuery

      attr_reader :data

      def initialize(data = nil, options={}, &block)
        @data= data
        @options = options
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def query(&block)
        @value[:query] = ElasticsearchSl::Queries::Query.new(@data, &block).to_hash
        @value
      end

      def filter(&block)
        @value[:filter] = ElasticsearchSl::Filters::Filter.new(@data, &block).to_hash
        @value
      end

      def function(&block)
        (@value[:functions] ||= []) << ElasticsearchSl::Shared::Function.new(@data, &block).to_hash
        @value
      end

      def boost(value)
        @value[:boost] = value
        @value
      end

      def score_mode(value)
        @value[:score_mode] = value
        @value
      end

      def max_boost(value)
        @value[:max_boost] = value
        @value
      end

      def to_hash
        @value.update(@options)
      end

      def to_json
        to_hash.to_json
      end
    end

  end
end