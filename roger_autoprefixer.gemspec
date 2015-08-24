# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "roger_autoprefixer"
  s.version = "1.2.0"

  s.authors = ["Flurin Egger"]
  s.email = ["info@digitpaint.nl", "flurin@digitpaint.nl"]
  s.homepage = "http://github.com/digitpaint/roger_autoprefixer"
  s.summary = "Rack middleware and processor for using autoprefixer with Roger."
  s.licenses = ["MIT"]

  s.date = Time.now.strftime("%Y-%m-%d")

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new(">= 0")
  end

  s.add_dependency("roger", [">= 0.11.0"])
  s.add_dependency("autoprefixer-rails", [">= 5.0.0"])

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "test-unit", "~> 3.1.2"
  s.add_development_dependency "rubocop", "~> 0.31.0"
end
