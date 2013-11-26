# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "redis-dist-mutex"
  spec.version       = '0.1.0'
  spec.authors       = ["ReSTARTR"]
  spec.email         = ["dev@vasily.jp"]
  spec.description   = %q{Distributed mutex using Redis}
  spec.summary       = <<-EOS
    Distributed mutex using Redis.
    Conpatible with redis Mutex.
    Enable to set expire to the lockfile. If set, act as like a setInterval in JavaScript.
  EOS
  spec.homepage      = "https://github.com/vasilyjp/redis-dist-mutex"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
end
