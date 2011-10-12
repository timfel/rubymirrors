require 'bundler'
Bundler::GemHelper.install_tasks

RUBY_ENGINE = 'ruby' unless defined? RUBY_ENGINE

desc "Run the specs on the given mirror api. Defaults to 'ruby'"
task :spec, :impl do |task, args|
  args.with_defaults :impl => RUBY_ENGINE
  sh "mspec -t #{args.impl} spec/*_spec.rb"
end

task :test    => :spec
task :default => :spec
