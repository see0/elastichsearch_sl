require 'spec_helper'

describe ElasticsearchSl::Queries::Query do

  subject do
    ElasticsearchSl::Queries::Query
  end

  let(:with_para) do
    subject.new(bar: 'foobar')
  end

  context 'match' do

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        match 'foo', data[:bar]
      end

      expect(result.to_hash).to eq({:match => {"foo" => {:query => "foobar"}}})
    end

    it 'accept options' do
      result = with_para.instance_eval do
        match 'foo', data[:bar], operator: 'and'
      end

      expect(result.to_hash).to eq({:match => {"foo" => {:query => "foobar", operator: 'and'}}})
    end

  end

  context 'match_phrase' do

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        match_phrase 'foo', data[:bar]
      end

      expect(result.to_hash).to eq({:match_phrase => {"foo" => {:query => "foobar"}}})
    end

    it 'accept options' do
      result = with_para.instance_eval do
        match_phrase 'foo', data[:bar], analyzer: 'my_analyzer'
      end

      expect(result.to_hash).to eq({:match_phrase => {"foo" => {:query => "foobar", analyzer: 'my_analyzer'}}})
    end
  end

  context 'match_phrase_prefix' do

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        match_phrase_prefix 'foo', data[:bar]
      end

      expect(result.to_hash).to eq({:match_phrase_prefix => {"foo" => {:query => "foobar"}}})
    end

    it 'accept options' do
      result = with_para.instance_eval do
        match_phrase_prefix 'foo', data[:bar], max_expansions: 10
      end

      expect(result.to_hash).to eq({:match_phrase_prefix => {"foo" => {:query => "foobar", max_expansions: 10}}})
    end
  end

  context 'multi_match' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        multi_match data[:bar], ['foo', 'bar']
      end

      expect(result.to_hash).to eq({:multi_match => {:query => "foobar", fields: ['foo', 'bar']}})
    end

    it 'accept options' do
      result = with_para.instance_eval do
        multi_match data[:bar], ['foo', 'bar'], type: :best_fields
      end

      expect(result.to_hash).to eq({:multi_match => {:query => "foobar", fields: ['foo', 'bar'], type: :best_fields}})
    end


  end

  context 'booelan' do

    it 'generate correct syntax' do
      result = with_para.instance_eval do
        boolean do
          should { match 'foo', data[:bar] }
          must { match 'foo', data[:bar] }
          must_not { match 'foo', data[:bar] }
        end
      end

      match_result = {:match => {"foo" => {:query => "foobar"}}}

      expect(result.to_hash).to eq(bool: {:should => [match_result], :must => [match_result], :must_not => [match_result]})
    end
  end

  context 'boosting' do
    it 'generate correct syntax' do
      result = with_para.instance_eval do
        boosting(negative_boost: 0.2) do
          positive do
            match 'foo', data[:bar]
          end
          negative do
            match 'foo', data[:bar]
          end
        end
      end

      match_result = {:match => {"foo" => {:query => "foobar"}}}

      expect(result.to_hash).to eq({:boosting => {:positive => [match_result], :negative => [match_result], :negative_boost => 0.2}})
    end
  end

  context 'common' do
    it 'generate correct syntax' do
      result = with_para.instance_eval do
        common 'foo', data[:bar], low_freq_operator: :and
      end

      expect(result.to_hash).to eq({common: {'foo' => {query: 'foobar', :low_freq_operator => :and}}})
    end
  end

  #TODO: uses filter.. defer later
  context 'constant_score' do

  end

  context 'dis_max' do
    it 'generate correct syntax' do

      result = with_para.instance_eval do
        dis_max(tie_breaker: 0.7) do

          query do
            match 'foo', data[:bar]
          end

          query do
            match 'foo', data[:bar]
          end

        end
      end

      match_result = {:match => {"foo" => {:query => "foobar"}}}

      expect(result.to_hash).to eq({dis_max: {:queries=>[match_result, match_result], :tie_breaker=>0.7}})
    end
  end

  #TODO: uses filter.. defer later
  context 'filtered' do

  end

  context 'fuzzy_like_this_field' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        fuzzy_like_this_field data[:bar], like_text: 'foo'
      end

      expect(result.to_hash).to eq(:fuzzy_like_this_field => {"foobar"=>{:like_text=>"foo"}})
    end
  end

  context 'ids' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        ids data[:bar], ['foo', 'bar']
      end

      expect(result.to_hash).to eq(:ids => {:values=>["foobar"], :type=>["foo", "bar"]})
    end
  end

  context 'match_all' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        match_all
      end

      expect(result.to_hash).to eq(:match_all => {})
    end

    it 'accept options' do
      result = with_para.instance_eval do
        match_all boost: 12
      end

      expect(result.to_hash).to eq(:match_all => {boost: 12})
    end


  end

  context 'nested' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        nested(path: 'foo' , score_mode: 'bar') do
          query do
            match 'foo', data[:bar]
          end
        end
      end

      match_result = {:match => {"foo" => {:query => "foobar"}}}

      expect(result.to_hash).to eq(:nested => {:query=>match_result, :path=>"foo", :score_mode=>"bar"})
    end


  end

  context 'prefix' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        prefix data[:bar], 'foo'
      end

      expect(result.to_hash).to eq(:prefix => {"foobar"=>"foo"})
    end

    it 'accept boost' do
      result = with_para.instance_eval do
        prefix data[:bar], 'foo', boost: 1
      end

      expect(result.to_hash).to eq(:prefix => {"foobar"=>{:value=>"foo", :boost=>1}})
    end
  end

  context 'query_string' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        query_string data[:bar], default_field: 'bar'
      end

      expect(result.to_hash).to eq({:query_string=>{:query=>"foobar", :default_field=>"bar"}})
    end
  end

  context 'range' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        range data[:bar], gte: 1, lte:2
      end

      expect(result.to_hash).to eq(:range => {"foobar"=>{:gte=>1, :lte=>2}})
    end
  end


  context 'term' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        term data[:bar], 'val' , boost: 1
      end

      expect(result.to_hash).to eq({:term=>{"foobar"=>{:value=>"val", :boost=>1}}})
    end
  end


  context 'terms' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        terms 'foo', [data[:bar] , 1], minimum_should_match: 1
      end

      expect(result.to_hash).to eq(:terms=>{'foo'=>["foobar", 1], :minimum_should_match=>1})
    end
  end

  context 'function score' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        function_score do
          query do
            terms 'foo', [data[:bar] , 1], minimum_should_match: 1
          end

          function do
            filter { terms data[:bar] , 'lol' }
            gauss 'foo' , scale: 2
          end

          boost 123
        end
      end

      expect(result.to_hash).to eq({:function_score=>{:query=>{:terms=>{"foo"=>["foobar", 1], :minimum_should_match=>1}}, :functions=>[{:filter=>{:terms=>{"foobar"=>["lol"]}}, :gauss=>{"foo"=>{:scale=>2}}}], :boost=>123}})
    end
  end


end