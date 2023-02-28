Given "fastlane is installed" do
  $fastlane_installed ||= begin
    step('I run the script "features/scripts/install-fastlane.sh" synchronously')
    true
  end
end

When("I run lane {string} with api_key set to {string}") do |lane, api_key|
  fastlane_upload_symbols(lane, nil, api_key)
end

When("I run lane {string} with dsym_path set to {string}") do |lane, dsym_path|
  fastlane_upload_symbols(lane, dsym_path)
end

When("I run lane {string} with dsym_path set to {string} and api_key set to {string}") do |lane, dsym_path, api_key|
  fastlane_upload_symbols(lane, dsym_path, api_key)
end

When("I run lane {string} with dsym_path set to {string}, api_key set to {string} and config_file set to {string}") do |lane, dsym_path, api_key, config_file|
  fastlane_upload_symbols(lane, dsym_path, api_key, config_file)
end

When("I run lane {string} with dsym_path set to {string}, api_key set to {string} and ignore_empty_dsym set to {string}") do |lane, dsym_path, api_key, ignore_empty_dsym|
  fastlane_upload_symbols(lane, dsym_path, api_key, nil, ignore_empty_dsym, nil)
end

When("I run lane {string} with dsym_path set to {string}, api_key set to {string} and ignore_missing_dwarf set to {string}") do |lane, dsym_path, api_key, ignore_missing_dwarf|
  fastlane_upload_symbols(lane, dsym_path, api_key, nil, nil, ignore_missing_dwarf)
end

Then("the exit status should be {int}") do |int|
  assert_equal(int, $?.exitstatus)
end

Then('the fastlane {word} payload field {string} equals {int}') do |request_type, field_path, int_value|
  assert_equal(int_value, Maze::Helper.read_key_path(Maze::Server.list_for(request_type).current[:body], field_path))
end

# Steps to allow assertions of dsym values. (Int value not used. Only included for visability in test output.)
Then('the {word} payload {int} field {string} is not null') do |request_type, field_index, field_path|
  list = Maze::Server.list_for(request_type)
  assert_not_nil(Maze::Helper.read_key_path(list.current[:body], field_path))
end

# Steps to allow assertions of api key values. (Int value not used. Only included for visability in test output.)
Then('the {word} payload {int} field {string} equals {string}') do |request_type, field_index, field_path, string_value|
  list = Maze::Server.list_for(request_type)
  assert_equal(string_value, Maze::Helper.read_key_path(list.current[:body], field_path))
end

# Allows movement to next item in request list. Ensures that all items in list can be checked. 
Then("I want to check the next {word} request") do |request_type|
  list = getList(request_type)
  list.next
  # Runs step to show number of remaining requests to process.
  step "I want to see how many #{request_type} requests are left to process"
end

# Function to print how many requests left to process. (count of remaining requests in queue.) Only included for visability in test output. 
And("I want to see how many {word} requests are left to process") do |request_type|
  list = getList(request_type)
  puts("There are #{list.size_remaining} #{request_type} requests left to process")
end

# Function for getting list of requests.
def getList(request_type)
  return Maze::Server.list_for(request_type)
end

