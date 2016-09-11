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

It also supports using a custom list of errors to ignore.

```ruby
UrlResolver.configure do |config|
  config.cache = Redis.new # default: nil
  config.cache_failures = true # default: true
  config.user_agent = 'Custom User-Agent' # default: 'Ruby'
  config.errors_to_ignore << MyModule::MyError
  config.timeout = 15
end
```

or 

```ruby
UrlResolver.configuration.cache = Redis.new
UrlResolver.configuration.cache_failures = true
UrlResolver.configuration.user_agent = 'Custom User-Agent'
UrlResolver.configuration.errors_to_ignore << MyModule::MyError
UrlResolver.configuration.timeout = 15
```

If you want to specify different options on a per-call basis (or you
prefer to not leverage the global configuration from above), you can
pass an optional hash to the `#resolve` method

```ruby
options = { :user_agent => 'Some Other User-Agent', :timeout => 60 }
UrlResolver.resolve('http://analytics.google.com', options)
# => "http://www.google.com/analytics/"
```

These options are passed to `RestClient`, so you can send any options
that `RestClient` acceptsm, such as `:max_redirects`


```ruby
options = { :max_redirects => 20 }
UrlResolver.resolve('http://analytics.google.com', options)
```

### Changelog

##### 0.2.1
+ Added timeout configuration option
+ Can pass a hash of options into the `#resolve` method to specify
configuration parameters on a per-call basis

##### 0.1.1
+ Handle redirects that resolve to nonstandard protocols

##### 0.1.0
+ Initial release

### Todo
+ configurable cache timeouts + keys
+ non-Redis caches
+ more configurable failure handling (request timeouts, bad URLs, etc)
+ support non-RestClient http clients
+ relax and enjoy life
