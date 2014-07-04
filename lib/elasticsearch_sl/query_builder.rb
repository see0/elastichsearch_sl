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

    #
    # def sort(&block)
    #   @sort = Sort.new(&block).to_ary
    #   self
    # end
    #
    # def facet(name, options={}, &block)
    #   @facets ||= {}
    #   @facets.update Facet.new(name, options, &block).to_hash
    #   self
    # end
    #
    # def filter(type, *options)
    #   @filters ||= []
    #   @filters << Filter.new(type, *options).to_hash
    #   self
    # end
    #
    # def script_field(name, options={})
    #   @script_fields ||= {}
    #   @script_fields.merge! ScriptField.new(name, options).to_hash
    #   self
    # end
    #
    # def highlight(*args)
    #   unless args.empty?
    #     @highlight = Highlight.new(*args)
    #     self
    #   else
    #     @highlight
    #   end
    # end
    #
    # def from(value)
    #   @from = value
    #   @options[:from] = value
    #   self
    # end
    #
    # def size(value)
    #   @size = value
    #   @options[:size] = value
    #   self
    # end
    #
    # def fields(*fields)
    #   @fields = Array(fields.flatten)
    #   self
    # end
    #
    # def partial_field(name, options)
    #   @partial_fields ||= {}
    #   @partial_fields[name] = options
    # end
    #
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
      @options[:payload] || begin
        request = {}
        request.update({:query => @query.to_hash}) if @query
        # request.update({:sort => @sort.to_ary}) if @sort
        # request.update({:facets => @facets.to_hash}) if @facets
        # request.update({:filter => @filters.first.to_hash}) if @filters && @filters.size == 1
        # request.update({:filter => {:and => @filters.map { |filter| filter.to_hash }}}) if  @filters && @filters.size > 1
        # request.update({:highlight => @highlight.to_hash}) if @highlight
        # request.update({:size => @size}) if @size
        # request.update({:from => @from}) if @from
        # request.update({:fields => @fields}) if @fields
        # request.update({:partial_fields => @partial_fields}) if @partial_fields
        # request.update({:script_fields => @script_fields}) if @script_fields
        # request.update({:version => @version}) if @version
        # request.update({:explain => @explain}) if @explain
        # request.update({:min_score => @min_score}) if @min_score
        # request.update({:track_scores => @track_scores}) if @track_scores
        request
      end
    end

    def to_json
      to_hash.to_json
    end

  end

end
