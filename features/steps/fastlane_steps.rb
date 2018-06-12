Given "fastlane is installed" do
  $fastlane_installed ||= begin
    step('I run the script "features/scripts/install-fastlane.sh" synchronously')
    true
  end
end

When("I run lane {string} with dsym_path set to {string}") do |lane, dsym_path|
  fastlane_upload_symbols(dsym_path)
end
