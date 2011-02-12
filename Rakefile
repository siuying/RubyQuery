require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rquery"
  gem.files = ["lib/*.rb", "lib/**/*.rb", "bin/*"]
  gem.executables = ['rquery']
  gem.homepage = "http://github.com/siuying/rquery"
  gem.license = "MIT"
  gem.summary = %Q{Simple jQuery style method to extract HTML}
  gem.description = %Q{RQuery is a simple jQuery style method to extract HTML}
  gem.email = "francis@ignition.hk"
  gem.authors = ["Francis Chong"]
  
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'nokogiri', '> 1.4.0'
  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |spec|
  # spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "helloworld #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('./lib/*.rb')
end
