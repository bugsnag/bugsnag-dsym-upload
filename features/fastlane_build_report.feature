Feature: Reporting build to Bugsnag using Fastlane

    Scenario: Report basic build 
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890AAAAAA"
        And the field "appVersion" for multipart request 0 equals "1.0.0"
        Then the build exit status should be 0

    Scenario: Report with appVersionCode (Android only)
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane android_version_code to "1234"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "appVersionCode" for multipart request 0 equals "1234"
        Then the build exit status should be 0

    Scenario: Report with appBundleVersion (IOS only)
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane ios_bundle_version to "1.2.3"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "appBundleVersion" for multipart request 0 equals "1.2.3"
        Then the build exit status should be 0

    Scenario: Report with releaseStage 
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane release_stage to "Production"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "releaseStage" for multipart request 0 equals "Production"
        Then the build exit status should be 0

    Scenario: Report with builderName
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane builder_name to "Bug Snag"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "builderName" for multipart request 0 equals "Bug Snag"
        Then the build exit status should be 0

    Scenario: Report with source control
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane repository to "www.github.com/a_repo/"
        And I set fastlane revision to "12345"
        And I set fastlane provider to "github"
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "sourceControl" for multipart request 0 is not null
        Then the build exit status should be 0

    Scenario: Report with single metadata
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane metadata to '"test1" : "First test"'
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "metadata" for multipart request 0 is not null
        Then the build exit status should be 0

    Scenario: Report with multiple metadata
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane metadata to '"test1": "First test", "test2": "Second test", "test3": "Third test"'
        And I run lane "send_build"
        Then I should receive 1 request
        And the field "apiKey" for multipart request 0 is not null
        And the field "appVersion" for multipart request 0 is not null
        And the field "metadata" for multipart request 0 is not null
        Then the build exit status should be 0

    Scenario: Report with all params (Android)
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"
        And I set fastlane android_version_code to "1234"
        And I set fastlane release_stage to "Production"
        And I set fastlane builder_name to "Bug Snag"
        And I set fastlane repository to "www.github.com/a_repo/"
        And I set fastlane revision to "12345"
        And I set fastlane provider to "github"
        And I set fastlane metadata to '"test1": "First test", "test2": "Second test", "test3": "Third test"'
        And I run lane "send_build"
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890AAAAAA"
        And the field "appVersion" for multipart request 0 equals "1.0.0"
        And the field "appVersionCode" for multipart request 0 equals "1234"
        And the field "releaseStage" for multipart request 0 equals "Production"
        And the field "builderName" for multipart request 0 equals "Bug Snag"
        And the field "sourceControl" for multipart request 0 is not null
        And the field "metadata" for multipart request 0 is not null
        Then the build exit status should be 0

    Scenario: Report with all params (IOS)
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I set fastlane app_version to "1.0.0"       
        And I set fastlane ios_bundle_version to "1.2.3"
        And I set fastlane release_stage to "Production"
        And I set fastlane builder_name to "Bug Snag"
        And I set fastlane repository to "www.github.com/a_repo/"
        And I set fastlane revision to "12345"
        And I set fastlane provider to "github"
        And I set fastlane metadata to '"test1": "First test", "test2": "Second test", "test3": "Third test"'
        And I run lane "send_build"
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890AAAAAA"
        And the field "appVersion" for multipart request 0 equals "1.0.0"
        And the field "appBundleVersion" for multipart request 0 equals "1.2.3"
        And the field "releaseStage" for multipart request 0 equals "Production"
        And the field "builderName" for multipart request 0 equals "Bug Snag"
        And the field "sourceControl" for multipart request 0 is not null
        And the field "metadata" for multipart request 0 is not null
        Then the build exit status should be 0

    Scenario: Throw failure if no API key
        When I set fastlane api_key to nil
        And I set fastlane app_version to "1.0.0"
        And I run lane "send_build"
        Then I should receive 0 requests
        Then the exit status should be 1

    Scenario: Throw failure if no app version
        When I set fastlane api_key to "1234567890ABCDEF1234567890AAAAAA"
        And I run lane "send_build"
        Then I should receive 0 requests
        Then the exit status should be 1

    Scenario: Throw failure if no params
        When I set no parameters
        And I run lane "send_build"
        Then I should receive 0 requests
        Then the exit status should be 1