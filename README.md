# bugsnag-upload

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

View usage information and options by running `fastlane action
upload_symbols_to_bugsnag`

## [License](LICENSE.txt)
