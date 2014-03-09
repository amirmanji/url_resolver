require 'rest-client'

class UrlResolver::Resolver
  attr_reader :cache

  def initialize(cache = nil)
    @cache = cache
  end

  def resolve(url)
    url_to_check = URI.escape(url)
    cached_url = cache.get("urls.#{url_to_check}")
    return cached_url if final_url.present?
  
    RestClient.head(URI.escape(url)).args[:url].tap do |final_url|
      cache.set("urls.#{url_to_check}", final_url)
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
    RestClient::Forbidden
  
    cache.set("urls.#{url_to_check}", url)
    url
  rescue Exception => e
    raise UrlResolverError.new("#{e.class.to_s}: #{url}")
  end
end
