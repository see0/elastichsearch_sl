module ElasticsearchSl
  module Filters
    class Filter

      attr_reader :data

      def initialize(data = nil, &block)
        @data = data
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def and_filter(options={}, &block)
        @and_filter ||= AndFilter.new(@data, options)
        block.arity < 1 ? @and_filter.instance_eval(&block) : block.call(@and_filter) if block_given?
        @value = @and_filter.to_hash
      end

      def or_filter(options={}, &block)
        @or_filter ||= OrFilter.new(@data, options)
        block.arity < 1 ? @or_filter.instance_eval(&block) : block.call(@or_filter) if block_given?
        @value = @or_filter.to_hash
      end

      def not_filter(options={}, &block)
        @not_filter ||= NotFilter.new(@data, options)
        block.arity < 1 ? @not_filter.instance_eval(&block) : block.call(@not_filter) if block_given?
        @value = @not_filter.to_hash
      end

      def exists(field)
        @value = {exists: {field: field}}
      end

      #todo: geo bounding box filter

      def geo_distance(field, options={})
        query = {lat: options.delelete(:lat), lon: options.delelete(:lon)} if options.is_a?(Hash) && options[:lat].any? && options[:lon].any?
        query = options if options.is_a?(String)

        @value = {geo_distance: {distance: options.delelete(:distance), field => query}}
      end

      def term(field, value, options={})
        @value = {term: {field => value}}.update(options)
      end

      def terms(field, value, options={})
        @value = {:terms => {field => Array(value)}}
        @value[:terms].update(options)
        @value
      end

      def range(field, value)
        @value = {:range => {field => value}}
      end


      def match_all(options = {})
        @value = {:match_all => options}
        @value
      end

      #create helper

      def boolean(options={}, &block)
        @boolean ||= ElasticsearchSl::Shared::Boolean.new(ElasticsearchSl::Queries::Filter, @data, options)
        block.arity < 1 ? @boolean.instance_eval(&block) : block.call(@boolean) if block_given?
        @value[:bool] = @boolean.to_hash
        @value
      end

      def to_json(options={})
        to_hash.to_json
      end

      def to_hash
        @value
      end
    end

  end
end
