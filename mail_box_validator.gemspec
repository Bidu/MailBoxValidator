# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail_box_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "mail_box_validator"
  spec.version       = MailBoxValidator::VERSION
  spec.authors       = ['Bidu Developers']
  spec.email         = ['dev@bidu.com.br']
  spec.summary       = 'Check if email box is valid'

  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
