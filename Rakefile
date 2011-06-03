require "rubygems"
require "spec"
require "spec/rake/spectask"

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--colour)
  t.libs = ["spec"]
end

task :default => ["spec"]