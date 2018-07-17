# How to contribute

* [Fork](https://help.github.com/articles/fork-a-repo) the
  [repository on github](https://github.com/bugsnag/bugsnag-cocoa)
* Commit and push until you are happy with your contribution
* Test your changes
* [Make a pull request](https://help.github.com/articles/using-pull-requests)
* Thanks!

## Running the tests

Install the dependencies with `make bootstrap`, then run the unit and
integration suites with `make test`

## Releasing a new version

1. Update the CHANGELOG with new content
2. Update the version number
   * Bump the version in the homebrew formula URL in `tools/homebrew`
   * Update the version in `VERSION`
   * Update the version in
     `tools/fastlane-plugin/lib/fastlane/plugin/bugsnag/version.rb`
3. Commit your changes
4. Tag the release
5. Push
   * Create a new GitHub release with the changes
   * Open `tools/fastlane-plugin` and run `rake release`
6. Update the documentation as needed on docs.bugsnag.com
