# frozen_string_literal: true

require "fileutils"
require "json"
require "pathname"
require "tmpdir"

class CacheGenerator
  CACHE_DIR = Pathname(__dir__)
    .parent
    .parent
    .then { |path| path / "cache" }
    .freeze
    .tap { |path| FileUtils.mkdir_p(path) }
  private_constant :CACHE_DIR

  def initialize(namespace:)
    raise ArgumentError, "Namespace can only contain a-zA-z0-9_" unless namespace.match?(/^\w+$/)

    @namespace = namespace
    @cache_items = {}
  end

  def add(name, &block)
    raise ArgumentError, "Missing block" unless block_given?
    raise ArgumentError, "Name can only contain a-zA-z0-9_" unless name.match?(/^\w+$/)
    raise ArgumentError, "Name already in cache" if @cache_items.key?(name)

    @cache_items[name] = block
    true
  end

  def generate
    readme_path = namespaced_cache_dir / "README.md"

    File.open(readme_path, "w") do |file|
      file.puts <<~README
        # Cache: #{@namespace}
        Each cache item shows a pretty printed sample of the JSON collection.

        ---
      README

      each_cache_item do |name, content|
        write_cache(name: name, content: content)

        file.puts <<~README

          ## Item: #{name}
          ```
          #{abbreviated_json(content)}
          ```
        README
      end
    end
  end

  def outdated
    Dir.mktmpdir do |tmp_dir|
      tmp_dir = Pathname(tmp_dir)

      each_cache_item do |name, content|
        write_cache(name: name, content: content, cache_dir: tmp_dir)
      end

      diff_command = [
        "diff",
        "--recursive",
        "--brief",
        "--new-file",
        "--exclude=README.md",
        tmp_dir.to_s,
        namespaced_cache_dir.to_s
      ]

      exit 1 unless system(*diff_command)
    end
  end

  private

  def write_cache(name:, content:, cache_dir: namespaced_cache_dir)
    path = cache_dir / file_name_for(name)
    File.write(path, JSON.generate(content))
  end

  def file_name_for(name)
    "#{name}.json"
  end

  def temp_path_for(name)
    temp_dir / file_name_for(name)
  end

  def namespaced_cache_dir
    @namespaced_cache_dir ||= (CACHE_DIR / @namespace)
      .freeze
      .tap { |path| FileUtils.mkdir_p(path) }
  end

  def content_for(name, &block)
    block.call.tap do |result|
      raise ArgumentError, "Expected a hash" unless result.is_a?(Hash)
    end
  rescue # rubocop:disable Style/RescueStandardError
    warn "Error: Failed to process `#{name}` cache"
    raise
  end

  def each_cache_item
    @cache_items.each do |name, block|
      yield [name, content_for(name, &block)]
    end
  end

  def abbreviated_json(content)
    content
      .take(20)
      .to_h
      .then(&JSON.method(:pretty_generate))
      .split("\n")
      .then { |lines| lines.size > 20 ? lines.take(20) + ["..."] : lines }
      .join("\n")
  end
end
