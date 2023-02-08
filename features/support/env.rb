Bundler.with_unbundled_env do
  Dir.chdir 'tools/fastlane-plugin' do
    `rake build`
  end
end

Bundler.with_unbundled_env do
  version = `cat VERSION`.chomp
  Dir.chdir 'features/fixtures/fl-project' do
    gem_path = Dir["../../../tools/fastlane-plugin/fastlane-plugin-bugsnag-#{version}.gem"].last
    `bundle config --local path vendor`
    `bundle install --gemfile=Gemfile`
    `bundle exec gem install #{gem_path}`
    `bundle update fastlane-plugin-bugsnag --local --gemfile=Gemfile` # use just-built gem
  end
end

def fastlane_upload_symbols(lane, dsym_path=nil, api_key=nil, config_file=nil, ignore_empty_dsym=nil, ignore_missing_dwarf=nil)
  api_key_env = "BUGSNAG_API_KEY='#{api_key}'" unless api_key.nil?
  config_file_env = "BUGSNAG_CONFIG_FILE='#{config_file}'" unless config_file.nil?
  dsym_path_env = "BUGSNAG_DSYM_PATH='#{dsym_path}'" unless dsym_path.nil?
  ignore_empty_dsym_env = "BUGSNAG_IGNORE_EMPTY_DSYM='#{ignore_empty_dsym}'" unless ignore_empty_dsym.nil?
  ignore_missing_dwarf_env = "BUGSNAG_IGNORE_MISSING_DWARF='#{ignore_missing_dwarf}'" unless ignore_missing_dwarf.nil?

  Bundler.with_unbundled_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:9339/sourcemap'\
       #{dsym_path_env} \
       #{api_key_env} \
       #{config_file_env} \
       #{ignore_empty_dsym_env} \
       #{ignore_missing_dwarf_env} \
       bundle exec fastlane #{lane}`
    end
  end
end

# Non active params automatically set to nil. No need to set manually here.
def fastlane_report_build(lane, api_key, app_version, android_version_code, ios_bundle_version, release_stage, builder_name, repository, revision, provider, metadata)
  api_key_env = "BUGSNAG_API_KEY='#{api_key}'" unless api_key.nil?
  app_version_env = "BUGSNAG_APP_VERSION='#{app_version}'" unless app_version.nil?
  android_version_code_env = "BUGSNAG_ANDROID_VERSION_CODE='#{android_version_code}'" unless android_version_code.nil?
  ios_bundle_version_env = "BUGSNAG_IOS_BUNDLE_VERSION='#{ios_bundle_version}'" unless ios_bundle_version.nil?
  release_stage_env = "BUGSNAG_RELEASE_STAGE='#{release_stage}'" unless release_stage.nil?
  builder_name_env = "BUGSNAG_BUILDER_NAME='#{builder_name}'" unless builder_name.nil?
  repository_env = "BUGSNAG_REPOSITORY='#{repository}'" unless repository.nil?
  revision_env = "BUGSNAG_REVISION='#{revision}'" unless revision.nil?
  provider_env = "BUGSNAG_PROVIDER='#{provider}'" unless provider.nil?
  metadata_env = "BUGSNAG_BUILD_METADATA='#{metadata}'" unless app_version.nil?

  Bundler.with_unbundled_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:#{MOCK_API_PORT}'\
      #{api_key_env} \
      #{app_version_env} \
      #{android_version_code_env} \
      #{ios_bundle_version_env} \
      #{release_stage_env} \
      #{builder_name_env} \
      #{repository_env} \
      #{revision_env} \
      #{provider_env} \
      #{metadata_env} \
      bundle exec fastlane #{lane}`
    end
  end
end