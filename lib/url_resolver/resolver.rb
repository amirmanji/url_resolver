module UrlResolver
  class Resolver
    def cache
      UrlResolver.configuration.url_cache
    end

    def user_agent
      UrlResolver.configuration.user_agent
    end

    def timeout
      UriResolver.configuration.timeout
    end

    def resolve(url, options={})
      url_to_check = URI.escape(url)
      cached_url = cache.get_url(url_to_check)
      return cached_url if cached_url

      default_options = { :user_agent => user_agent, :timeout => timeout }
      options = default_options.merge(options)

      response = RestClient.head(url_to_check, options)
      response.args[:url].tap do |final_url|
        cache.set_url(url_to_check, final_url)
      end
    rescue *UrlResolver.configuration.errors_to_ignore => e

      if e.message == 'getaddrinfo: nodename nor servname provided, or not known'
        response = RestClient.head(url_to_check) { |response, request, result, &block| response }
        url = response.headers[:location] if response.code == 302 && response.headers[:location]
      end

      cache.set_url(url_to_check, url) if UrlResolver.configuration.cache_failures
      url
    rescue Exception => e
      if e.message =~ /undefined method `request_uri'/
        cache.set_url(url_to_check, url) if UrlResolver.configuration.cache_failures
        url
      else
        raise UrlResolverError.new("#{e.class.to_s}: #{url} (#{e.message})")
      end
    end
  end
end
