module ElasticsearchSl
  class QueryBuilder

    attr_reader :data, :facets, :filters, :options, :explain, :script_fields

    def initialize(opt = {}, &block)
      @options = opt[:options] || {}
      @data = opt[:data]

      block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
    end

    def query(&block)
      @query = Queries::Query.new(@data)
      block.arity < 1 ? @query.instance_eval(&block) : block.call(@query)
      self
    end


    def aggs(&block)
      @aggs = Aggs::Agg.new(@data)
      block.arity < 1 ? @aggs.instance_eval(&block) : block.call(@aggs)
      self
    end

    def filter(&block)
      @filter = Filters::Filter.new(@data)
      block.arity < 1 ? @filter.instance_eval(&block) : block.call(@filter)
      self
    end


    def sort(&block)
      @sort ||= Commons::Sort.new(&block)
      @options[:sort] = @sort.to_ary
      self
    end

    def script_field(name, options={})
      sf ||= {}
      sf.merge! Commons::ScriptField.new(name, options).to_hash
      @options[:script_fields] = sf
      self
    end

    def source_filtering(options = {})
      @options[:_source] = options
      self
    end

    # def highlight(*args)
    #   unless args.empty?
    #     @highlight = Highlight.new(*args)
    #     self
    #   else
    #     @highlight
    #   end
    # end
    #
    def from(value)
      @from = value
      @options[:from] = value
      self
    end

    def size(value)
      @size = value
      @options[:size] = value
      self
    end

    def fields(*fields)
      @options[:fields] = Array(fields.flatten)
      self
    end

    # def explain(value)
    #   @explain = value
    #   self
    # end
    #
    # def version(value)
    #   @version = value
    #   self
    # end
    #
    # def min_score(value)
    #   @min_score = value
    #   self
    # end
    #
    # def track_scores(value)
    #   @track_scores = value
    #   self
    # end

    def to_hash
        request = @options
        request.update({:query => @query.to_hash}) if @query
        request.update({:aggs => @aggs.to_hash}) if @aggs
        request.update({:filter => @filter.to_hash}) if @filter
        request
    end

    def to_json
      to_hash.to_json
    end


    alias :aggregations :aggs
  end

end
