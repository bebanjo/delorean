require "rubygems"
require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(--colour)
end

task :default => ["spec"]