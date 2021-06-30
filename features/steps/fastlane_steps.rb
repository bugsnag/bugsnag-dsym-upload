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

When("I run lane {string} with dsym_path set to {string}, api_key set to {string} and allow_missing_dwarf set to {string}") do |lane, dsym_path, api_key, allow_missing_dwarf|
  fastlane_upload_symbols(lane, dsym_path, api_key, nil, nil, allow_missing_dwarf)
end


Then("the exit status should be {int}") do |int|
  assert_equal(int, $?.exitstatus)
end