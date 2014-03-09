class UrlResolver::Cache
  def initialize(cache)
    @cache = cache
  
    if cache.class.name == 'Redis'
      extend CacheImplementations::RedisCache
    elsif cache.class.name == 'NilClass'
      extend CacheImplementations::NilClassCache
    else
      raise ArgumentError.new("Invalid cache class: #{cache.class}")
    end
  end
end
