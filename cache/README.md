# Cache Basics

This is essentially a bunch of static files (mostly JSON) that are pre-computed to speed up the program.

You can check if the cache is outdated with the `rake cache:outdated` command and re-generate all files with the `rake cache:generate` command. To make sure it's always up-to-date we even check for this on CI.

There are a few scripts to generate the cache and they can all be found in the `script/` directory.

Note: Sample data can be found in the `README.md` file in each subdirectory.

## Scripts

### script/generate_search_index.rb

As the name would suggest, this generates a bunch of search indexes that are basic JSON files with string to string mappings (no nested nonsense). These are used primarily to speed up partial matches though pre-computing things also means we don't have to pull in the internationalization libraries for 90+ languages which also makes a difference.

### script/generate_formatted_output.rb

This is where we generate the formatted output so that we don't need to include runtime dependencies to load country, currency and region information.

### script/generate_list.rb

This script generates a few simple lists of countries and regions.

## Reading

Reading from the cached files is quite easy. Just use the `Atlas::Cache` module to load the file using the namespace and file name. Each file gets lazy loaded the first time it's referenced and then memoized. Specified in `lib/atlasq/cache.rb`.

```rb
string = Atlas::Cache.get("space/text_file.txt")
```

## Helpers

### script/shared/cache_generator.rb

This class provides a simple wrapper around the whole cache generation process. The namespace specifies which sub-folder should hold these 

```rb
cache = CacheGenerator.new(namespace: "space")
```

Add a new cached file using the return value from a `#add` block.

```rb
cache.add "cache_file" do
  ...
end
```

Text files (.txt) are created when the block returns a string. The following code adds a text file to the cache at `cache/space/text_file.txt`.

```rb
cache.add "text_file" do
  "text"
end
```

JSON files (.json) are created when the block doesn't return a string. The following code adds a text file to the cache at `cache/space/json_file.json`.

```rb
cache.add "json_file" do
  %w[data data data]
end
```

Use the `#generate` method to re-generate all cache files in the namespace.

```rb
cache.generate
```

Use the `#outdated` method to check if the cache files are outdated since they last time they were generated. If any files are outdated, it will print there names and exit with a non-zero exit code. It generates the files internally and uses `diff` to determine if the files are outdated.

```rb
cache.outdated
```
