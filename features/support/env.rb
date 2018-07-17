Bundler.with_clean_env do
  Dir.chdir 'tools/fastlane-plugin' do
    `rake build`
  end
  Dir.chdir 'features/fixtures/fl-project' do
    `bundle install`
  end
end

def fastlane_upload_symbols dsym_path
  Bundler.with_clean_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:#{MOCK_API_PORT}'\
       BUGSNAG_DSYM_PATH='#{dsym_path}' \
       bundle exec fastlane upload_symbols`
    end
  end
end
