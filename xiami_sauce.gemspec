lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "xiami_sauce"
  spec.version       = File.open('VERSION') { |f| f.read }
  spec.authors       = ["Wanzhang Sheng"]
  spec.email         = ["ranmocy@gmail.com"]
  spec.description   = %q{A Xiami Downloader.}
  spec.summary       = %q{A Xiami Downloader.}
  spec.homepage      = "http://ranmocy.github.com/xiami_sauce"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'version'
end
