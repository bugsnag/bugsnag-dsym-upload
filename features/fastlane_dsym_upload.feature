Feature: Uploading dSYMs to Bugsnag using Fastlane

    Scenario: Uploading dSYMs from a single zip file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null

    Scenario: Uploading dSYMs from an array of paths
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip,dsym2.zip"
        Then I should receive 4 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        And the field "dsym" for multipart request 2 is not null
        And the field "dsym" for multipart request 3 is not null

    Scenario: Uploading dSYMs from a directory
        When I run lane "upload_symbols" with dsym_path set to "dsyms/"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null

    Scenario: Uploading dSYMs with a zip filename containing spaces and special characters
        When I run lane "upload_symbols" with dsym_path set to "some dir/some files β.app.dSYM.zip"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null

    Scenario: Uploading dSYMs using API key and config file together uses api key from config file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890abcde" and config_file set to "TestList.plist"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "random-key"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "random-key"

    Scenario: Uploading dSYMs using API key and empty config file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890ABCDEF1234567890ABCDEF" and config_file set to "NoApiKey.plist"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"

    Scenario: Uploading dSYMs with an invalid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "invalid-key"
        Then I should receive 0 requests

    Scenario: Uploading dSYMs with an valid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"

    Scenario: Uploading dSYMs using shared values from other plugins
        When I run lane "upload_symbols_with_custom_action" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 4 request
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 2 is not null
        And the field "apiKey" for multipart request 2 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 3 is not null
        And the field "apiKey" for multipart request 3 equals "1234567890ABCDEF1234567890ABCDEF"

