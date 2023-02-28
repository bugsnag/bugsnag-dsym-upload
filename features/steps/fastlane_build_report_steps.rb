Given "fastlane is installed" do
    $fastlane_installed ||= begin
      step('I run the script "features/scripts/install-fastlane.sh" synchronously')
      true
    end
  end

  # Default request values. Values not set in scenario remain as nil.
  @api_key = nil
  @app_version = nil
  @android_version_code = nil
  @ios_bundle_version = nil
  @release_stage = nil
  @builder_name = nil
  @repository = nil
  @revision = nil
  @provider = nil
  @metadata = nil

  # Steps to set request parameters. If step not called in scenario param left as nil.
  When ("I set fastlane api_key to {string}") do |api_key|
    @api_key = api_key
  end

  And ("I set fastlane app_version to {string}") do |app_version|
    @app_version = app_version
  end

  And ("I set fastlane android_version_code to {string}") do |android_version_code|
    @android_version_code = android_version_code
  end

  And ("I set fastlane ios_bundle_version to {string}") do |ios_bundle_version|
    @ios_bundle_version = ios_bundle_version
  end

  And ("I set fastlane release_stage to {string}") do |release_stage|
    @release_stage = release_stage
  end

  And ("I set fastlane builder_name to {string}") do |builder_name|
    @builder_name = builder_name
  end

  And ("I set fastlane repository to {string}") do |repository|
    @repository = repository
  end

  And ("I set fastlane revision to {string}") do |revision|
    @revision = revision
  end

  And ("I set fastlane provider to {string}") do |provider|
    @provider = provider
  end

  And ("I set fastlane metadata to {string}") do |metadata|
    @metadata = metadata
  end

  # Runs lane, passing all params with non active params passed as nil
  And ("I run lane {string}") do |lane|
    fastlane_report_build(lane, @api_key, @app_version, @android_version_code, @ios_bundle_version, @release_stage, @builder_name, @repository, @revision, @provider, @metadata)
  end

  Then ("the build exit status should be {int}") do |int|
    assert_equal(int, $?.exitstatus)
  end

  # Steps to allow failures to be tested.
  When ("I set fastlane api_key to nil") do 
    # Mothing happens here
  end

  When ("I set no parameters") do 
    # Nothing happens here
  end 
