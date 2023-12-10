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

        ---
      README

      each_cache_item do |name, content|
        file_name = file_name_for(name: name, content: content)
        write_cache(file_name: file_name, content: content)

        file.puts <<~README

          ## Item: #{file_name}

          ### Content Sample
          Sample of the first 20 pretty printed lines of the file.

          ```
          #{abbreviated_content(content)}
          ```
        README

        first =
          case content
          when Array then content.first
          when Hash then content.first.last
          end

        next unless first.is_a?(Hash)

        file.puts <<~README

          ### Result Schema
          Fields available in the result hash.

          ```
          #{JSON.pretty_generate(first.keys)}
          ```
        README
      end
    end
  end

  def outdated
    Dir.mktmpdir do |tmp_dir|
      tmp_dir = Pathname(tmp_dir)

      each_cache_item do |name, content|
        file_name = file_name_for(name: name, content: content)
        write_cache(file_name: file_name, content: content, cache_dir: tmp_dir)
      end

      diff_command = [
        "diff",
        "--recursive",
        "--brief",
        "--new-file",
        "--exclude=README.md",
        tmp_dir.to_s,
        namespaced_cache_dir.to_s,
      ]

      exit 1 unless system(*diff_command)
    end
  end

  private

  def write_cache(file_name:, content:, cache_dir: namespaced_cache_dir)
    path = cache_dir / file_name
    content = JSON.generate(content) unless content.is_a?(String)
    File.write(path, content)
  end

  def file_name_for(name:, content:)
    case content
    when String
      "#{name}.txt"
    else
      "#{name}.json"
    end
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
      next unless result.respond_to?(:empty?)
      next unless result.empty?

      raise StandardError, "Missing: cache content is empty"
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

  def abbreviated_content(content)
    text =
      if content.is_a?(String)
        content
      else
        JSON.pretty_generate(content)
      end

    lines = text.split("\n")
    lines = lines.take(20) + ["..."] if lines.size > 20
    lines.join("\n")
  end
end
