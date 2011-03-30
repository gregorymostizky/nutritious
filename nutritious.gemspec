# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "nutritious"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Gregory Mostizky"]
  s.email       = ["gregory.mostizky@gmail.com"]
  s.homepage    = "http://arubyguy.com"
  s.summary     = %q{Reads bookmark stream from del.icio.us}
  s.description = %q{Reads bookmark stream from del.icio.us}

  s.rubyforge_project = "nutritious"

  s.add_dependency('i18n')
  s.add_dependency('hpricot')
  s.add_dependency('feedzirra')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
