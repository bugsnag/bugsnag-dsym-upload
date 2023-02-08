require 'spec_helper'
require 'json'
require 'fastlane/actions/get_info_plist_value'

BuildAction = Fastlane::Actions::SendBuildToBugsnagAction

describe BuildAction do
  def run_with args
    BuildAction.run(Fastlane::ConfigurationHelper.parse(BuildAction, args))
  end

  context 'building an iOS project' do
    it 'detects default Info.plist file excluding test dirs' do
      expect(BuildAction).to receive(:send_notification) do |url, body|
        payload = ::JSON.load(body)
        expect(payload['appVersion']).to eq '2.0-other'
        expect(payload['appBundleVersion']).to eq '22'
        expect(payload['apiKey']).to eq '12345678901234567890123456789AAA'
      end

      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
        run_with({})
      end
    end

    it 'reads api key from legacy location' do
      # the API key is now in `bugsnag.apiKey`, it used to be in 'BugsnagAPIKey',
      # test this can be extracted correctly from the `ios_proj_legacy`
      expect(BuildAction).to receive(:send_notification) do |url, body|
        payload = ::JSON.load(body)
        expect(payload['appVersion']).to eq '4.0-project'
        expect(payload['appBundleVersion']).to eq '44'
        expect(payload['apiKey']).to eq '12345678901234567890123456789BBB'
      end

      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj_legacy')) do
        run_with({})
      end
    end

    context 'using default config_file option' do
      context 'override API key from config' do
        it 'reads API key from the api_key option' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['apiKey']).to eq '12345678901234567890123456789FFF'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              api_key: '12345678901234567890123456789FFF'
            })
          end
        end

        it 'uses input versions from options' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '8.0.0'
            expect(payload['appBundleVersion']).to eq '800'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              app_version: '8.0.0',
              ios_bundle_version: '800'
            })
          end
        end
      end
    end

    context 'override config_file option' do
      it 'reads API key and version info from the config file' do
        expect(BuildAction).to receive(:send_notification) do |url, body|
          payload = ::JSON.load(body)
          expect(payload['appVersion']).to eq '3.0-project'
          expect(payload['appBundleVersion']).to eq '33'
          expect(payload['apiKey']).to eq '12345678901234567890123456789DDD'
        end

        Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
          run_with({
            config_file: File.join('Project', 'Info.plist')
          })
        end
      end

      context 'override API key, and config file' do
        it 'uses the input api_key to override a non default config' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '3.0-project'
            expect(payload['appBundleVersion']).to eq '33'
            expect(payload['apiKey']).to eq '12345678901234567890123456789EEE'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              config_file: File.join('Project', 'Info.plist'),
              api_key: '12345678901234567890123456789EEE'
            })
          end
        end

        it 'uses the input versions to override a non default config' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '9.0.0'
            expect(payload['appBundleVersion']).to eq '900'
            expect(payload['apiKey']).to eq '12345678901234567890123456789DDD'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              config_file: File.join('Project', 'Info.plist'),
              app_version: '9.0.0',
              ios_bundle_version: '900'
            })
          end
        end
      end
    end

    context 'metadata added to payload' do
      it "single key:value pair added" do
        expect(BuildAction).to receive(:send_notification) do |url, body|
          payload = ::JSON.load(body)
          expect(payload['appVersion']).to eq '4.0-project'
          expect(payload['apiKey']).to eq '12345678901234567890123456789DDD'
          expect(payload['metadata']).to eq '"test1": "First test"'
        end

        Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
          run_with({
            app_version: '4.0-project',
            api_key: '12345678901234567890123456789DDD',
            metadata: '"test1": "First test"'
          })
        end
      end
      
      it "multiple key:value pairs added" do
        expect(BuildAction).to receive(:send_notification) do |url, body|
          payload = ::JSON.load(body)
          expect(payload['appVersion']).to eq '4.0-project'
          expect(payload['apiKey']).to eq '12345678901234567890123456789DDD'
          expect(payload['metadata']).to eq '"test1": "First test", "test2": "Second test", "test3": "Third test"'
        end

        Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
          run_with({
            app_version: '4.0-project',
            api_key: '12345678901234567890123456789DDD',
            metadata: '"test1": "First test", "test2": "Second test", "test3": "Third test"'
          })
        end
      end
    end
  end
end
