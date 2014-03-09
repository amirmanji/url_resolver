require 'spec_helper'

describe UrlResolver::Resolver do
  subject { UrlResolver::Resolver.new }
  
  describe '#resolve' do
    before(:each) do
      RestClient.stub_chain('head.args').and_return({url: 'http://www.boogle.com'})
    end
    
    it 'returns the URL that RestClient finds' do
      subject.resolve('http://www.google.com').should eq('http://www.boogle.com')
    end
    
    it 'returns cached URLs' do
      subject.cache.stub(:get_url).and_return('http://www.doogle.com')
      subject.resolve('http://www.google.com').should eq('http://www.doogle.com')
    end
    
    it 'caches found URLs' do
      subject.cache.should_receive(:set_url).with(anything, 'http://www.boogle.com')
      subject.resolve('http://www.google.com')
    end
    
    it 'raises an error with the URL if an unknown exception occurs' do
      RestClient.stub(:head).and_raise(FakeException)
      expect{ subject.resolve('http://www.google.com') }
        .to raise_error(UrlResolver::UrlResolverError, /http:\/\/www.google.com/)
    end
    
    describe 'if an expected exception is raised' do
      before(:each) do
        RestClient.stub(:head).and_raise(SocketError)
      end
      
      it 'returns the original URL' do
        subject.resolve('http://www.google.com').should eq('http://www.google.com')
      end
      
      it 'caches the original URL as the result' do
        subject.cache.should_receive(:set_url).with(anything, 'http://www.google.com')
        subject.resolve('http://www.google.com')
      end
      
      describe 'if cache_failures is false' do
        before(:each) do
          UrlResolver.configuration.stub(:cache_failures).and_return(false)
        end
        
        it 'should not cache the original URL as the result' do
          subject.cache.should_not_receive(:set_url)
          subject.resolve('http://www.google.com')
        end
      end
    end
  end
  
end
