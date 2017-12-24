lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sql_formatter_web_interface/version'

Gem::Specification.new do |spec|
  spec.name          = 'sql_formatter_web_interface'
  spec.version       = SqlFormatterWebInterface::VERSION
  spec.authors       = ['Maurizio De Santis']
  spec.email         = ['desantis.maurizio@gmail.com']

  spec.summary       = 'SQL formatter web interface - Web interface for SQL formatting'
  spec.description   = 'It lets you format SQL via web SQL formatting services'
  spec.homepage      = 'https://github.com/mdesantis/sql_formatter_web_interface'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(examples|test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport', '~> 5.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'heredoc_unindent', '~> 1.2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.0'
end
