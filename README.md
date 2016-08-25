# bugsnag-upload

Commands for uploading files to Bugsnag via the Bugsnag Upload APIs


## Current Features

* Uploads dSYM files in bulk
* Converts bitcode-enabled symbol files stripped of symbol names into full files

## Installation

### Basic

Copy `bin/bugsnag-dsym-upload` into your `PATH`, or run `make install` to
install to the default directory, `/usr/lib/bin`.

### Homebrew

Install via the [Homebrew](https://brew.sh) formula:

```
brew install --HEAD \
  https://raw.github.com/bugsnag/dsym-upload/master/tools/homebrew/bugsnag-dsym-upload.rb
```

## [Usage](man/bugsnag-dsym-upload.pod)

## [License](LICENSE.txt)
