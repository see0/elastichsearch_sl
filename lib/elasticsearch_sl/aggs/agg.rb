module ElasticsearchSl
  module Aggs
    class Agg

      attr_accessor :value
      attr_reader :data

      def initialize(data, &block)
        @data = data
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def aggs(&block)
        @agg ||= ElasticsearchSl::Aggs::Agg.new(@data)
        block.arity < 1 ? @agg.instance_eval(&block) : block.call(@agg) if block_given?
        @value[:aggs] = @agg.to_hash
        @value
      end

      def block(name, &block)
        @block ||= ElasticsearchSl::Aggs::Agg.new(@data)
        block.arity < 1 ? @block.instance_eval(&block) : block.call(@block) if block_given?
        @value[name] = @block.to_hash
        @value
      end

      def stats(name, field, options={})
        @value = {stats: {field: field}}.merge(options)
      end

      def terms(field, options={})
        @value = {terms: {:field => field}.update(options)}
      end

      def to_json(options={})
        to_hash.to_json
      end

      def to_hash
        @value
      end

      alias :aggregations :aggs
      alias :b :block
    end

  end
end
