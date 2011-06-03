# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name = "delorean"
  gem.version = "1.0.1"
  gem.date  = Date.today.to_s

  gem.summary = "Delorean lets you travel in time with Ruby by mocking Time.now"
  
  gem.authors = ["Luismi Cavallé", "Sergio Gil"]
  gem.email = "ballsbreaking@bebanjo.com"
  gem.homepage = "http://github.com/bebanjo/delorean"

  gem.extra_rdoc_files = ["README.rdoc"]
  gem.files = ["lib/delorean.rb", "README.rdoc", "MIT-LICENSE"]
  
  gem.add_runtime_dependency 'chronic', '>= 0'
  
  gem.add_development_dependency 'rspec', '~> 1.3.0'
  gem.add_development_dependency 'activesupport', '~> 2.3.0'
  gem.add_development_dependency 'rake'
end
