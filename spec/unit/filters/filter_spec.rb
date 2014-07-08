require 'spec_helper'

describe ElasticsearchSl::Filters::Filter do

  subject do
    ElasticsearchSl::Filters::Filter
  end

  let(:with_para) do
    subject.new(bar: 'foobar')
  end

  context 'exists' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        exists 'cool'
      end

      expect(result.to_hash).to eq({:exists=>{:field=>"cool"}})
    end
  end

  context 'geo_distance' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        geo_distance 'cool', distance: '100mi', lat: 123 , lon: 123
      end

      expect(result.to_hash).to eq({:geo_distance=>{:distance=>"100mi", "cool"=>{:lat=>123, :lon=>123}}})
    end
  end


  context 'and' do

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        and_filter do
          filter { exists 'cool'}
        end
      end

      expect(result.to_hash).to eq(:and=>[{:exists=>{:field=>"cool"}}])
    end

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        and_filter do
          geo_distance 'cool', distance: '100mi', lat: 123 , lon: 123
        end
      end

      expect(result.to_hash).to eq({:and=>[{:geo_distance=>{:distance=>"100mi", "cool"=>{:lat=>123, :lon=>123}}}]})
    end


  end
end