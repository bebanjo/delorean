# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delorean}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luismi Cavall\303\251", "Sergio Gil"]
  s.date = %q{2010-11-15}
  s.email = %q{ballsbreaking@bebanjo.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["spec", "lib/delorean.rb", "README.rdoc"]
  s.homepage = %q{http://github.com/bebanjo/delorean}
  s.rdoc_options = ["--main", "README.rdoc", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Delorean lets you travel in time with Ruby by mocking Time.now}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.0"])
    else
      s.add_dependency(%q<chronic>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.0"])
    end
  else
    s.add_dependency(%q<chronic>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.0"])
  end
end
