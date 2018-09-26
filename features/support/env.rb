Bundler.with_clean_env do
  Dir.chdir 'tools/fastlane-plugin' do
    `rake build`
  end
end

Bundler.with_clean_env do
  Dir.chdir 'features/fixtures/fl-project' do
    gem_path = Dir['../../../tools/fastlane-plugin/fastlane-plugin-bugsnag-*.gem'].last
    `bundle config --local path vendor`
    `bundle install --gemfile=Gemfile`
    `gem install #{gem_path} -i vendor`
  end
end

def fastlane_upload_symbols(lane, dsym_path, api_key=nil, config_file=nil)
  api_key_env = "BUGSNAG_API_KEY='#{api_key}'" unless api_key.nil?
  config_file_env = "BUGSNAG_CONFIG_FILE='#{config_file}'" unless config_file.nil?

  Bundler.with_clean_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:#{MOCK_API_PORT}'\
       BUGSNAG_DSYM_PATH='#{dsym_path}' \
       #{api_key_env} \
       #{config_file_env} \
       bundle exec fastlane #{lane}`
    end
  end
end
