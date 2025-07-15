Feature: Uploading dSYMs to Bugsnag using Fastlane

    Scenario: Uploading dSYMs from a single zip file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs from an array of paths
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip,dsym2.zip" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 4 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs from a directory
        When I run lane "upload_symbols" with dsym_path set to "dsyms/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs with a zip filename containing spaces and special characters
        When I run lane "upload_symbols" with dsym_path set to "some dir/some files β.app.dSYM.zip" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs using API key and config file together uses api key from input parameter
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890ABCDEF1234567890ABCDEF" and config_file set to "TestList.plist"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs using API key and empty config file
        When I run lane "upload_symbols" with dsym_path set to "dsyms.zip", api_key set to "1234567890ABCDEF1234567890ABCDEF" and config_file set to "NoApiKey.plist"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs with an invalid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "invalid-key"
        And I wait to receive 0 sourcemaps
        Then the exit status should be 1

    Scenario: Uploading dSYMs with an valid API key as a parameter
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "dsyms/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 0

    Scenario: Uploading dSYMs after running `gym` Fastlane action
        When I run lane "upload_symbols_after_gym" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 1


    Scenario: Uploading dSYMs after running `download_dsyms` Fastlane action
        When I run lane "upload_symbols_after_download_dsyms" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 1

    Scenario: Uploading dSYMs after running `gym` and  `download_dsyms` Fastlane actions
        When I run lane "upload_symbols_after_gym_and_download_dsyms" with api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 2 sourcemaps
        Then the sourcemap is valid for the dSYM Build API
        Then the sourcemaps Content-Type header is valid multipart form-data
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        And I discard the oldest sourcemap
        And the sourcemap payload field "dsym" is not null
        And the sourcemap payload field "apiKey" equals "1234567890ABCDEF1234567890ABCDEF"
        Then the exit status should be 1

    Scenario: Skipping over a zero byte dSYM file with Error
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "ZeroByteDsym/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 0 sourcemaps
        Then the exit status should be 1

    Scenario: Skipping over a zero byte dSYM file with Warning, when --ignore-empty-dsym flag enabled
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "ZeroByteDsym/", api_key set to "1234567890ABCDEF1234567890ABCDEF" and ignore_empty_dsym set to "true"
        And I wait to receive 0 sourcemaps
        Then the exit status should be 1

    Scenario: Throw failure if dSYM is missing DWARF data
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "MissingDWARFdSYM/" and api_key set to "1234567890ABCDEF1234567890ABCDEF"
        And I wait to receive 0 sourcemaps
        Then the exit status should be 1

    Scenario: Throw warning if dSYM is missing DWARF data, when --ignore-missing-dwarf flag enabled
        When I run lane "upload_symbols_with_api_key" with dsym_path set to "MissingDWARFdSYM/", api_key set to "1234567890ABCDEF1234567890ABCDEF" and ignore_missing_dwarf set to "true"
        And I wait to receive 0 sourcemaps
        Then the exit status should be 1
