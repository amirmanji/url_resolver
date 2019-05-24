require 'spec_helper'

describe UrlResolver::Cache do
  describe '#initialize' do
    it 'raises ArugmentError if an invalid cache is specified' do
      expect { UrlResolver::Cache.new("test") }.to raise_error(ArgumentError)
    end
    
    it 'can set and get for NilClass' do
      cache = UrlResolver::Cache.new(nil)
      expect(cache).to respond_to(:get_url)
      expect(cache).to respond_to(:set_url)
    end
    
    it 'can set and get for Redis' do
      cache = UrlResolver::Cache.new(Redis.new)
      expect(cache).to respond_to(:get_url)
      expect(cache).to respond_to(:set_url)
    end
  end
end
