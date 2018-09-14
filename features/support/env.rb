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

def fastlane_upload_symbols dsym_path
  Bundler.with_clean_env do
    Dir.chdir 'features/fixtures/fl-project' do
      `BUGSNAG_ENDPOINT='http://localhost:#{MOCK_API_PORT}'\
       BUGSNAG_DSYM_PATH='#{dsym_path}' \
       bundle exec fastlane upload_symbols`
    end
  end
end
