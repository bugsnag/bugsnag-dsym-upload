Feature: Uploading dSYMs to Bugsnag using Fastlane

    Scenario: Uploading dSYMs from a single zip file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs from an array of paths
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip,dsym2.zip"
        Then I should receive 4 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        And the field "dsym" for multipart request 2 is not null
        And the field "dsym" for multipart request 3 is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs from a directory
        When I run lane "upload_symbols" with dsym_path set to "dsyms/"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs with a zip filename containing spaces and special characters
        When I run lane "upload_symbols" with dsym_path set to "some dir/some files β.app.dSYM.zip"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs using API key and config file together uses api key from input parameter
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890ABCDEF1234567890AAAAAA" and config_file set to "TestList.plist"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890AAAAAA"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890AAAAAA"
        Then the exit status should be 0

    Scenario: Uploading dSYMs using API key and empty config file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890ABCDEF1234567890ABCDEF" and config_file set to "NoApiKey.plist"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs with an invalid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "invalid-key"
        Then I should receive 0 requests
        Then the exit status should be 1

    Scenario: Uploading dSYMs with an valid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 2 requests
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs after running `gym` Fastlane action
        When I run lane "upload_symbols_after_gym" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 4 request
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 2 is not null
        And the field "apiKey" for multipart request 2 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 3 is not null
        And the field "apiKey" for multipart request 3 equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0
    
    Scenario: Uploading dSYMs after running `download_dsyms` Fastlane action
        When I run lane "upload_symbols_after_download_dsyms" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 4 request
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 2 is not null
        And the field "apiKey" for multipart request 2 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 3 is not null
        And the field "apiKey" for multipart request 3 equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs after running `gym` and  `download_dsyms` Fastlane actions
        When I run lane "upload_symbols_after_gym_and_download_dsyms" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 5 request
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 1 is not null
        And the field "apiKey" for multipart request 1 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 2 is not null
        And the field "apiKey" for multipart request 2 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 3 is not null
        And the field "apiKey" for multipart request 3 equals "1234567890ABCDEF1234567890ABCDEF"
        And the field "dsym" for multipart request 4 is not null
        And the field "apiKey" for multipart request 4 equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Skipping over a zero byte dSYM file with Error
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "ZeroByteDsym/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 0 requests
        Then the exit status should be 1

    Scenario: Skipping over a zero byte dSYM file with Warning, when --ignore-empty-dsym flag enabled
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "ZeroByteDsym/", api_key set to "1234567890ABCDEF1234567890ABCDEF" and ignore_empty_dsym set to "true"
        Then I should receive 0 requests
        Then the exit status should be 0

    Scenario: Throw failure if dSYM is missing DWARF data
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "MissingDWARFdSYM/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        Then I should receive 0 requests
        Then the exit status should be 1

    Scenario: Throw warning if dSYM is missing DWARF data, when --ignore-missing-dwarf flag enabled
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "MissingDWARFdSYM/", api_key set to "1234567890ABCDEF1234567890ABCDEF" and ignore_missing_dwarf set to "true"
        Then I should receive 0 requests
        Then the exit status should be 0
