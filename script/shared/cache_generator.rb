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

  # @param namespace [String] the subdirectory name in the cache/ directory
  def initialize(namespace:)
    raise ArgumentError, "Namespace can only contain a-zA-z0-9_" unless namespace.match?(/^[a-zA-z0-9_]+$/)

    @namespace = namespace
    @cache_items = {}
  end

  # Add a new cache file for the data returned from the block.
  # The block must return a JSON serializable value.
  #
  # @param name [String] must be unique per instance of this class
  def add(name, &block)
    raise ArgumentError, "Missing block" unless block_given?
    raise ArgumentError, "Name can only contain a-zA-z0-9_" unless name.match?(/^\w+$/)
    raise ArgumentError, "Name already in cache" if @cache_items.key?(name)

    @cache_items[name] = block
    true
  end

  # Generate the cached documents that were added with `#add` along with
  # a readme page summarizing their contents in the namespaced subdirectory.
  def generate
    generate_cache_and_readme(cache_dir: namespaced_cache_dir)
  end

  # Check that the cached documents are up-to-date by diffing them against
  # a newly generated directory of cached documents.
  def outdated
    Dir.mktmpdir do |tmp_dir|
      tmp_dir = Pathname(tmp_dir)

      generate_cache_and_readme(cache_dir: tmp_dir)

      diff_command = [
        "diff",
        "--recursive",
        "--brief",
        "--new-file",
        tmp_dir.to_s,
        namespaced_cache_dir.to_s,
      ]

      exit 1 unless system(*diff_command)
    end
  end

  private

  # @param cached_dir [Pathname]
  def generate_cache_and_readme(cache_dir:)
    readme_path = cache_dir / "README.md"

    File.open(readme_path, "w") do |file|
      file.puts <<~README
        # Cache: #{@namespace}

        ---
      README

      each_cache_item do |name, content|
        file_name = file_name_for(name: name, content: content)
        write_cache(file_name: file_name, content: content, cache_dir: cache_dir)

        file.puts <<~README

          ## Item: #{@namespace}/#{file_name}

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

  # @param file_name [String]
  # @param cache_dir [Pathname]
  def write_cache(file_name:, content:, cache_dir:)
    path = cache_dir / file_name
    content = JSON.generate(content) if file_name.end_with?(".json")
    File.write(path, content)
  end

  # @param name [String]
  # @param content
  # @return [String] either .txt or .json based on content
  def file_name_for(name:, content:)
    case content
    when String
      "#{name}.txt"
    else
      "#{name}.json"
    end
  end

  # @return [Pathname]
  def namespaced_cache_dir
    @namespaced_cache_dir ||= (CACHE_DIR / @namespace)
      .freeze
      .tap { |path| FileUtils.mkdir_p(path) }
  end

  # @param name [String]
  # @return content
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

  # @yield [name, content]
  def each_cache_item
    @cache_items.each do |name, block|
      yield [name, content_for(name, &block)]
    end
  end

  # @param content
  # @return [String]
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
