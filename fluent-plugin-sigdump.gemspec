lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|

  s.name     = "fluent-plugin-sigdump"
  s.version  = "1.0.0"
  s.license  = "Apache-2.0"
  s.summary  = "Fluentd plugin to collect debug information"
  s.authors  = ["Fukuda Daijiro", "Fujimoto Seiji"]
  s.email    = ["fukuda@clear-code.com", "fujimoto@clear-code.com"]
  s.files    = Dir['lib/**/*.rb'] + ['LICENSE', 'README.md']
  s.homepage = "https://github.com/fluent-plugins-nursery/fluent-plugin-sigdump"

  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", '~> 2.0'
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "test-unit", "~> 3.3"

  s.add_runtime_dependency "sigdump", "~> 0.2.5"
  s.add_runtime_dependency "fluentd", [">= 1.9.3", "< 2"]
end
