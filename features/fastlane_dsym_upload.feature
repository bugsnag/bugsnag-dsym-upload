Feature: Uploading dSYMs to Bugsnag using Fastlane

    Scenario: Uploading dSYMs from a single zip file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip"
        Then I should receive 2 requests
        And the part "dsym" for request 0 is not null
        And the part "dsym" for request 1 is not null

    Scenario: Uploading dSYMs from an array of paths
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip,dsym2.zip"
        Then I should receive 4 requests
        And the part "dsym" for request 0 is not null
        And the part "dsym" for request 1 is not null
        And the part "dsym" for request 2 is not null
        And the part "dsym" for request 3 is not null

    Scenario: Uploading dSYMs from a directory
        When I run lane "upload_symbols" with dsym_path set to "dsyms/"
        Then I should receive 2 requests
        And the part "dsym" for request 0 is not null
        And the part "dsym" for request 1 is not null
