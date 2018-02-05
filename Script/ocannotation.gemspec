# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ocannotation/version"

Gem::Specification.new do |spec|
  spec.name          = "ocannotation"
  spec.version       = Ocannotation::VERSION
  spec.authors       = ["Ant Financial Wealth Mobile Team"]
  spec.email         = ["lianjie.lj@alibaba-inc.com"]

  spec.summary       = %q{OCAnnotation 脚本工具}
  spec.description   = %q{OCAnnotation 脚本工具}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "'http://xxx.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect agvim ainst " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "xcodeproj"
  spec.add_development_dependency "psych"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "colored"
  spec.add_development_dependency "json"
  spec.add_development_dependency "fileutils"

  
  spec.add_runtime_dependency "bundler", "~> 1.15"
  spec.add_runtime_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "xcodeproj"
  spec.add_runtime_dependency "psych"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "colored"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "fileutils"

end
