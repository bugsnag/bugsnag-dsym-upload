Bundler.with_unbundled_env do
  Dir.chdir 'tools/fastlane-plugin' do
    `rake build`
  end
end

Bundler.with_unbundled_env do
  Dir.chdir 'features/fixtures/fl-project' do
    gem_path = Dir['../../../tools/fastlane-plugin/fastlane-plugin-bugsnag-*.gem'].last
    `bundle config --local path vendor`
    `bundle install --gemfile=Gemfile`
    `bundle exec gem install #{gem_path}`
  end
end

def fastlane_upload_symbols(lane, dsym_path=nil, api_key=nil, config_file=nil)
  api_key_env = "BUGSNAG_API_KEY='#{api_key}'" unless api_key.nil?
  config_file_env = "BUGSNAG_CONFIG_FILE='#{config_file}'" unless config_file.nil?
  dsym_path_env = "BUGSNAG_DSYM_PATH='#{dsym_path}'" unless dsym_path.nil?

  Bundler.with_unbundled_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:#{MOCK_API_PORT}'\
       #{dsym_path_env} \
       #{api_key_env} \
       #{config_file_env} \
       bundle exec fastlane #{lane}`
    end
  end
end
