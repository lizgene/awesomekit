lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'awesomekit'

Gem::Specification.new do |gem|
  gem.name          = Awesomekit::NAME
  gem.version       = Awesomekit::VERSION
  gem.date          = Date.today.to_s

  gem.summary       = 'Command Line Interface for interacting with the Typekit API'
  gem.description   = 'Possibly the most "Awesome" CLI for Typekit Ever'
  gem.authors       = ['Liz Hubertz']
  gem.email         = 'liz.hubertz@gmail.com'
  gem.files         = Dir['lib/**/*.rb']
  gem.homepage      = 'https://github.com/lizhubertz/awesomekit'
  gem.license       = 'MIT'

  gem.executables   = ['awesomekit']

  gem.require_paths = ['lib']

  gem.add_dependency 'thor', '~> 0.19.1'
  gem.add_dependency 'httparty', '~> 0.14.0'
  gem.add_dependency 'formatador', '~> 0.2.5'

  gem.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  gem.add_development_dependency 'webmock', '~> 1.21', '>= 1.21.0'
  gem.add_development_dependency 'vcr', '~> 2.9', '>= 2.9.3'
end
