require 'rest-client'

module UrlResolver
  class Resolver
    def cache
      UrlResolver.configuration.url_cache
    end

    def resolve(url)
      url_to_check = URI.escape(url)
      cached_url = cache.get_url(url_to_check)
      return cached_url if cached_url
      
      response = RestClient.head(url_to_check)
      response.args[:url].tap do |final_url|
        cache.set_url(url_to_check, final_url)
      end
    rescue SocketError,
      Errno::ETIMEDOUT,
      RestClient::InternalServerError,
      RestClient::ServiceUnavailable,
      RestClient::BadRequest,
      RestClient::GatewayTimeout,
      RestClient::RequestTimeout,
      RestClient::ResourceNotFound,
      RestClient::BadGateway,
      RestClient::Forbidden => e
      
      if e.message == 'getaddrinfo: nodename nor servname provided, or not known'
        response = RestClient.head(url_to_check) { |response, request, result, &block| response }
        url = response.headers[:location] if response.code == 302 && response.headers[:location]
      end
  
      cache.set_url(url_to_check, url) if UrlResolver.configuration.cache_failures
      url
    
    rescue Exception => e
      raise UrlResolverError.new("#{e.class.to_s}: #{url}")
    end
  end
end
