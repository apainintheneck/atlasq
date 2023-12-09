# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "tempfile"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test lint]

desc "Shortcut for `rake rubocop`"
task lint: :rubocop

desc "Shortcut for `rake rubocop:autocorrect`"
task fix: :"rubocop:autocorrect"

namespace "readme" do
  desc "Check if the readme needs to be regenerated"
  task :outdated do
    Tempfile.open("readme") do |file|
      sh "bundle exec ruby script/generate_readme.rb > #{file.path}"
      sh "diff -q README.md #{file.path}"
    end
  end

  desc "Regenerate the readme"
  task :generate do
    Tempfile.open("readme") do |file|
      sh "bundle exec ruby script/generate_readme.rb > #{file.path}"
      mv file.path, "README.md"
    end
  end
end
