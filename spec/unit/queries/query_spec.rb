require 'spec_helper'

describe ElasticsearchSl::Queries::Query do

  subject do
    ElasticsearchSl::Queries::Query
  end

  context 'match query' do

    it 'generate correct es syntax' do
      result = subject.new(bar: 'foobar') do
        match 'foo', data[:bar]
      end

      expect(result.to_hash).to eq({:match => {"foo" => {:query => "foobar"}}})
    end

    it 'accept options' do
      result = subject.new(bar: 'foobar') do
        match 'foo', data[:bar], operator: 'and'
      end

      expect(result.to_hash).to eq({:match => {"foo" => {:query => "foobar", operator: 'and'}}})
    end

  end

  context 'match_phrase' do

  end

  context 'match_phrase_prefix' do

  end

  context 'multi_match' do

  end


end