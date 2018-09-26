Given "fastlane is installed" do
  $fastlane_installed ||= begin
    step('I run the script "features/scripts/install-fastlane.sh" synchronously')
    true
  end
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