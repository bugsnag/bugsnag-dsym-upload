# How to contribute

* [Fork](https://help.github.com/articles/fork-a-repo) the
  [repository on github](https://github.com/bugsnag/bugsnag-dsym-upload)
* Commit and push until you are happy with your contribution
* Test your changes
* [Make a pull request](https://help.github.com/articles/using-pull-requests)
* Thanks!

## Running the tests

Install the dependencies with `make bootstrap`, then run the unit and
integration suites with `make test`

## Testing the fastlane plugin

Open the `tools/fastlane-plugin` directory, then:

1. Build the gem using `rake build`
2. Install the built gem using `gem install fastlane-plugin-bugsnag-{version}.gem`
3. Add the plugin to your Fastlane project using `fastlane add_plugin bugsnag`

## Releasing a new version

1. Update the CHANGELOG with new content
2. Update the version numbers:
   * Update the version in `VERSION`
   * Update the version in `tools/fastlane-plugin/lib/fastlane/plugin/bugsnag/version.rb`
3. Commit your changes
4. Tag the release
5. Push:
   * Create a new GitHub release with the changes
   * Open `tools/fastlane-plugin` and run `rake release`
6. Homebrew:
   * Create a new Pull Request on the Bugsnag Homebrew tap repo `bugsnag/homebrew-tap` and update `Formula/bugsnag-dsym-upload.rb` with the following:
   * Update the `url` in the formula to the new `.tar.gz` release
   * Update the `sha256` checksum value in the formula. You can get this by creating a new formula with `brew create <link_to_new_.tar.gz>`
7. Update the documentation as needed on docs.bugsnag.com
