Feature: Uploading dSYMs to Bugsnag

    Scenario: Uploading a directory of dSYM files
        When I upload dSYMS with options "features/fixtures"
        Then I should receive a request
        And the HTTP version is "1.1" for request 0
        And the field "dsym" for multipart request 0 is not null
        Then the exit status should be 0

    Scenario: Uploading a zip file containing dSYM files
        When I upload dSYMS with options "features/fixtures/dsyms.zip"
        Then I should receive 2 requests
        And the HTTP version is "1.1" for request 0
        And the HTTP version is "1.1" for request 1
        And the field "dsym" for multipart request 0 is not null
        And the field "dsym" for multipart request 1 is not null
        Then the exit status should be 0

    Scenario: Uploading dSYMs with a project root
        When I upload dSYMS with options "--project-root /Users/jenkins/build/app/ features/fixtures"
        Then I should receive a request
        And the HTTP version is "1.1" for request 0
        And the field "dsym" for multipart request 0 is not null
        And the field "projectRoot" for multipart request 0 equals "/Users/jenkins/build/app/"
        And the payload field "apiKey" is null for request 0
        Then the exit status should be 0

    Scenario: Uploading dSYMs with API key
        When I upload dSYMS with options "--api-key 1234567890ABCDEF features/fixtures"
        Then I should receive a request
        And the HTTP version is "1.1" for request 0
        And the field "dsym" for multipart request 0 is not null
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF"
        And the payload field "projectRoot" is null for request 0
        Then the exit status should be 0

    Scenario: Uploading dSYMs with a project root and API key
        When I upload dSYMS with options "--project-root /Users/jenkins/build/app/ --api-key 1234567890ABCDEF features/fixtures"
        Then I should receive a request
        And the HTTP version is "1.1" for request 0
        And the field "dsym" for multipart request 0 is not null
        And the field "projectRoot" for multipart request 0 equals "/Users/jenkins/build/app/"
        And the field "apiKey" for multipart request 0 equals "1234567890ABCDEF"
        Then the exit status should be 0
