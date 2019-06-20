require 'spec_helper'

describe UrlResolver::Resolver do
  subject { UrlResolver::Resolver.new }
  
  describe '#resolve' do
    before(:each) do
      stub_request(:head, 'http://www.google.com').to_return(status: 302, headers: { location: 'http://www.boogle.com' })
      stub_request(:head, 'http://www.boogle.com').to_return(status: 200)
    end
    
    it 'returns the URL that RestClient finds' do
      expect(subject.resolve('http://www.google.com')).to eq('http://www.boogle.com')
    end
    
    it 'returns cached URLs' do
      allow(subject.cache).to receive(:get_url) { 'http://www.doogle.com' }
      expect(subject.resolve('http://www.google.com')).to eq('http://www.doogle.com')
    end
    
    it 'caches found URLs' do
      expect(subject.cache).to receive(:set_url).with(anything, 'http://www.boogle.com')
      subject.resolve('http://www.google.com')
    end
    
    it 'raises an error with the URL if an unknown exception occurs' do
      stub_request(:head, 'http://www.google.com').and_raise(FakeException)
      expect{ subject.resolve('http://www.google.com') }
        .to raise_error(UrlResolver::UrlResolverError, /http:\/\/www.google.com/)
    end
    
    describe 'with an expected exception' do
      before(:each) do
        stub_request(:head, 'http://www.google.com').and_raise(SocketError)
      end
      
      it 'returns the original URL' do
        expect(subject.resolve('http://www.google.com')).to eq('http://www.google.com')
      end
      
      it 'caches the original URL as the result' do
        expect(subject.cache).to receive(:set_url).with(anything, 'http://www.google.com')
        subject.resolve('http://www.google.com')
      end
      
      describe 'if cache_failures is false' do
        before(:each) do
          expect(UrlResolver.configuration).to receive(:cache_failures) { false }
        end
        
        it 'should not cache the original URL as the result' do
          expect(subject.cache).to_not receive(:set_url)
          subject.resolve('http://www.google.com')
        end
      end
    end

    it 'should resolve incomplete redirects to non-http' do
      first_url = 'https://legit.com/path'
      second_url = 'market://search?q=com.bundle.id'
      stub_request(:head, first_url).to_return(status: 302, headers: { location: second_url })
      expect(subject.resolve(first_url)).to eq(second_url)
    end

    it 'should resolve incomplete multi-redirects to non-http' do
      first_url = 'https://legit.com/path'
      second_url = 'https://legit.com/another'
      third_url = 'market://search?q=com.bundle.id'
      stub_request(:head, first_url).to_return(status: 302, headers: { location: second_url })
      stub_request(:head, second_url).to_return(status: 302, headers: { location: third_url })
      expect(subject.resolve(first_url)).to eq(third_url)
    end

    it 'should resolve incomplete redirects to http' do
      first_url = 'https://legit.com/path'
      second_url = 'https://search?q=com.bundle.id'
      stub_request(:head, first_url).to_return(status: 302, headers: { location: second_url })
      stub_request(:head, second_url).to_raise(SocketError.new('getaddrinfo: nodename nor servname provided, or not known'))
      expect(subject.resolve(first_url)).to eq(second_url)
    end
  end
  
end
