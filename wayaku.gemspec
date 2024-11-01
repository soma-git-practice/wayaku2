# frozen_string_literal: true

require_relative "lib/wayaku/version"

Gem::Specification.new do |spec|
  spec.authors = ["soma"]
  spec.files =  Dir['lib/**/*.rb']
  spec.name = "wayaku"
  spec.summary = 'モデルの属性を和訳する'.freeze
  spec.version = Wayaku::VERSION

  spec.add_dependency 'sqlite3', '~> 1.7.3'
  spec.add_dependency 'activerecord', '~> 7.1.3.2'
  spec.add_dependency 'enumerize'
  spec.add_development_dependency 'minitest', '~> 5.12', '>= 5.12.2'
  spec.add_development_dependency 'pry', '~> 0.14.2'
end
