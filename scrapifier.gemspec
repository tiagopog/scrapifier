# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'scrapifier'
  spec.version       = Scrapifier::VERSION
  spec.authors       = ['Tiago Guedes']
  spec.email         = ['tiagopog@gmail.com']
  spec.description   = 'A very simple way to extract meta information from URIs using the screen scraping technique.'
  spec.summary       = 'Extends the Ruby String class with a screen scraping method.'
  spec.homepage      = 'https://github.com/tiagopog/scrapifier'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.md)
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec',   '~> 2.14'
  spec.add_development_dependency 'rake',    '~> 10.1'
end
