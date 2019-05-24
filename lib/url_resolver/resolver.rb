module UrlResolver
  class Resolver
    def cache
      UrlResolver.configuration.url_cache
    end

    def user_agent
      UrlResolver.configuration.user_agent
    end

    def timeout
      UrlResolver.configuration.timeout
    end

    def resolve(url)
      url_to_check = URI.escape(url)
      cached_url = cache.get_url(url_to_check)
      return cached_url if cached_url

      last_location = url
      RestClient::Request.execute(method: :head,
                                  url: url_to_check,
                                  header: { user_agent: user_agent },
                                  timeout: timeout) do |response, request, result, &block|
        last_location = response.headers[:location] if response.code == 302 && response.headers[:location]
        response.return!(&block)
      end

      last_location.tap do |final_url|
        cache.set_url(url_to_check, final_url)
      end
    rescue *UrlResolver.configuration.errors_to_ignore => e
      if e.message == 'getaddrinfo: nodename nor servname provided, or not known'
        # final hostname could not be found
        url = last_location
      end
      cache.set_url(url_to_check, url) if UrlResolver.configuration.cache_failures
      url
    rescue Exception => e
      if e.message =~ /undefined method `request_uri'/
        # non-http URI
        cache.set_url(url_to_check, last_location) if UrlResolver.configuration.cache_failures
        last_location
      else
        raise UrlResolverError.new("#{e.class.to_s}: #{url} (#{e.message})")
      end
    end
  end
end
