# url_resolver

url_resolver follows redirects to resolve URLs. It's pretty alright.

### Installation

Gemfile:

    gem 'url_resolver'

Rubygems:

    gem install url_resolver

### Usage

```ruby
UrlResolver.resolve('http://www.google.com')
# => "http://www.google.com"

UrlResolver.resolve('http://analytics.google.com')
# => "http://www.google.com/analytics/"
```

### Configuration

url_resolver supports caching in case you're planning on hitting a lot of the same URLs over and over and over and over again.

```ruby
UrlResolver.configure do |config|
  config.cache = Redis.new # default: nil
  config.cache_failures = true # default: true
end
```

or 

```ruby
UrlResolver.configuration.cache = Redis.new
UrlResolver.cache_failures = true
```

### Changelog

##### 0.1.0
+ Initial release

### Todo
+ configurable cache timeouts + keys
+ non-Redis caches
+ more configurable failure handling (request timeouts, bad URLs, etc)
+ support non-RestClient http clients
+ relax and enjoy life
