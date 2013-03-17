RVM_PREFIX = "env -u RUBYOPT rvm 1.8.7,1.9.3-p327,2.0.0 do"
BUNDLE_CMD = lambda { puts "Bundling gems..."; puts `#{RVM_PREFIX} bundle install` }

guard 'bundler' do
  watch(/^.+\.gemspec/, &BUNDLE_CMD)
  watch('Gemfile', &BUNDLE_CMD)
end

guard 'rspec', cli: "--color --format documentation" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
