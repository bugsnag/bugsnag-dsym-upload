Feature: Uploading dSYMs to Bugsnag using Fastlane

    Scenario: Uploading dSYMs from a single zip file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip"
        Then I wait to receive 2 sourcemaps
        And I want to see how many sourcemaps requests are left to process
        And the sourcemaps payload field "dsym" is not null
        Then I want to check the next sourcemaps request
        And the sourcemaps payload field "dsym" is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs from an array of paths
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip,dsym2.zip"
        Then I wait to receive 4 sourcemaps
        And I want to see how many sourcemaps requests are left to process
        And the sourcemaps payload 0 field "dsym" is not null
        Then I want to check the next sourcemaps request
        And the sourcemaps payload 1 field "dsym" is not null
        Then I want to check the next sourcemaps request
        And the sourcemaps payload 2 field "dsym" is not null
        Then I want to check the next sourcemaps request
        And the sourcemaps payload 3 field "dsym" is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs from a directory
        When I run lane "upload_symbols" with dsym_path set to "dsyms/"
        Then I wait to receive 2 sourcemaps
        And I want to see how many sourcemaps requests are left to process
        And the sourcemaps payload 0 field "dsym" is not null
        Then I want to check the next sourcemaps request
        And the sourcemaps payload 1 field "dsym" is not null
        Then the exit status should be 0
    