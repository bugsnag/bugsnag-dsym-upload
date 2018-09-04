# bugsnag-dsym-upload

Commands for uploading files to Bugsnag via the Bugsnag Upload APIs


## Current Features

* Uploads dSYM files in bulk
* Converts bitcode-enabled symbol files stripped of symbol names into full files

## Installation

### Basic

Copy `bin/bugsnag-dsym-upload` into your `PATH`, or run `make install` to
install to the default directory, `/usr/lib/bin`.

View usage [here](man/bugsnag-dsym-upload.pod) or using `man
bugsnag-dsym-upload`

### Homebrew

Install via the [Homebrew](https://brew.sh) formula:

```
brew install \
  https://raw.github.com/bugsnag/bugsnag-upload/master/tools/homebrew/bugsnag-dsym-upload.rb
```

View usage [here](man/bugsnag-dsym-upload.pod) or using `man
bugsnag-dsym-upload`

### [Fastlane](https://fastlane.tools)

Add `bugsnag` as a plugin in your configuration:

```
fastlane add_plugin bugsnag
```

Then add the `upload_symbols_to_bugsnag` action to your lane:

```ruby
lane :refresh_dsyms do
  download_dsyms
  upload_symbols_to_bugsnag
  clean_build_artifacts
end
```

Common options:

* `dsym_path`: A path or array of paths for directories containing \*.dSYM files
  or a single \*.zip file to upload. If unspecified, the default behavior is to
  upload the zip files retrieved by a prior invocation of
  [`download_dsyms`](https://docs.fastlane.tools/actions/#download_dsyms), or
  any .dSYM files within the current directory.
* `upload_url`: The URL of the server receiving symbol files. Update this value
  if you are using a private instance of Bugsnag
* `api_key`: The API Key associated with the project. Informs Bugsnag which project 
  this dSYM should be applied to. If not provided, the dSYM can be applied to any 
  Bugsnag project.

View usage additional usage information and options by running `fastlane action
upload_symbols_to_bugsnag`.

Check out the [example `Fastfile`](tools/fastlane-plugin/fastlane/Fastfile) to
see how to use this plugin.  Try it by cloning the repo, running `fastlane
install_plugins` and `bundle exec fastlane test`.

If you have trouble using plugins, check out the [Plugins
Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
guide.

## [License](LICENSE.txt)
