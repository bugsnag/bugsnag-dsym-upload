## 1.3.2 (2018-03-23)

### Bug fixes

* Change format of temp directory generation to support running on Linux
  [#15](https://github.com/bugsnag/bugsnag-dsym-upload/pull/15)
  [#14](https://github.com/bugsnag/bugsnag-dsym-upload/issues/14)

* Halt when attempting to upload the contents of a malformed zip file
  [Philihp Busby](https://github.com/philihp)
  [#13](https://github.com/bugsnag/bugsnag-dsym-upload/pull/13)

## 1.3.1 (2018-03-07)

### Bug fixes

* (fastlane) Exclude `Info.plist` files in test directories from detected a the
  default location for build info
  [#11](https://github.com/bugsnag/bugsnag-dsym-upload/issues/11)
  [#12](https://github.com/bugsnag/bugsnag-dsym-upload/pull/12)
* (fastlane) Prefer build info values populated from a specified `config_file`
  if the default config file is overridden
  [#11](https://github.com/bugsnag/bugsnag-dsym-upload/issues/11)
  [#12](https://github.com/bugsnag/bugsnag-dsym-upload/pull/12)

## 1.3.0 (2018-02-14)

### Enhancements

* Automatically detect configuration file locations in React Native projects

### Bug fixes

* Print correct message when app version is not found. Previously a message
  about API key was printed.
* Prefer configuration based on the lane platform if available. Previously
  Android was assumed to be the default if the configuration files were present.

## 1.2.1 (2018-01-12)

* Validate and send source control provider for hosted versions of GitHub,
  GitLab, and Bitbucket

## 1.2.0 (2018-01-11)

### Enhancements

* Add action to the Fastlane plugin to upload builds to Bugsnag. Use
  `send_build_to_bugsnag` to get started.

## 1.1.0 (2017-05-08)

### Enhancements

* Add Fastlane plugin and action to upload dSYM files
* Support uploading a .zip archive containing dSYM files
* Improve error messages, add summary at the end

## 1.0.2 (2016-11-14)

### Enhancements

* Support dSYM paths containing commas

## 1.0.1 (2016-10-26)

### Enhancements

* Support dSYM paths containing spaces

## 1.0.0 (2016-08-26)

Initial release

### Enhancements

* Support debug symbol file (dSYM) upload
* Support adding symbols to bitcode-enabled dSYM binaries
