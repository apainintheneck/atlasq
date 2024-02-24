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

task default: %i[lint test readme:outdated cache:outdated]

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

namespace "cache" do
  desc "Check if the cache needs to be regenerated"
  task :outdated do
    sh "bundle exec ruby script/generate_search_index.rb outdated"
    sh "bundle exec ruby script/generate_formatted_output.rb outdated"
    sh "bundle exec ruby script/generate_list.rb outdated"
  end

  desc "Regenerate the cache"
  task :generate do
    sh "bundle exec ruby script/generate_search_index.rb generate"
    sh "bundle exec ruby script/generate_formatted_output.rb generate"
    sh "bundle exec ruby script/generate_list.rb generate"
  end
end
