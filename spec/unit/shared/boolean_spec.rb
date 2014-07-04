require 'spec_helper'

describe ElasticsearchSl::Shared::Boolean do

  subject do
    ElasticsearchSl::Shared::Boolean.new(ElasticsearchSl::Queries::Query)
  end

  let(:query) do
     q = ElasticsearchSl::Queries::Query.new
     q.match('cool', 'awesome')
     q.to_hash
  end

  context '#must' do
    before { subject.must { match 'cool', 'awesome' } }
    it "should wrap query within the block" do
      expect(subject.to_hash[:must].first).to eq query
    end
  end

  context '#should' do
    before { subject.should { match 'cool', 'awesome' } }
    it "should wrap query within the block" do
      expect(subject.to_hash[:should].first).to eq query
    end
  end

  context '#must_not' do
    before { subject.must_not { match 'cool', 'awesome' } }
    it "should wrap query within the block" do
      expect(subject.to_hash[:must_not].first).to eq query
    end
  end



end