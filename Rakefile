require 'bundler'
Bundler::GemHelper.install_tasks

desc "Run the specs on the given mirror api. Defaults to 'ruby'"
task :spec, :impl do |task, args|
  puts cmd = %{MIRRORS=#{args.impl || RUBY_ENGINE} mspec -t #{RUBY_ENGINE} spec/*_spec.rb}
  sleep 1
  system cmd
end
