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
        expect(payload['appVersion']).to eq '3.0-other'
        expect(payload['appBundleVersion']).to eq '56'
        expect(payload['apiKey']).to eq '3443f00f3443f00f3443f00f3443f00f'
      end

      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
        run_with({})
      end
    end

    it 'reads api key from legacy location' do
      expect(BuildAction).to receive(:send_notification) do |url, body|
        payload = ::JSON.load(body)
        expect(payload['apiKey']).to eq 'legacy-key'
      end

      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj_legacy')) do
        BuildAction.run(load_default_opts)
      end
    end

    context 'using default config_file option' do
      context 'override API key option' do
        it 'reads API key from the api_key option' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['apiKey']).to eq 'baobab'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              api_key: 'baobab'
            })
          end
        end

        it 'reads version info from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '4.0.0'
            expect(payload['appBundleVersion']).to eq '400'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              app_version: '4.0.0',
              ios_bundle_version: '400'
            })
          end
        end
      end
    end

    context 'override config_file option' do
      it 'reads API key and version info from the config file' do
        expect(BuildAction).to receive(:send_notification) do |url, body|
          payload = ::JSON.load(body)
          expect(payload['appVersion']).to eq '2.0-project'
          expect(payload['appBundleVersion']).to eq '6'
          expect(payload['apiKey']).to eq 'faaffaaffaaffaaffaaffaaffaaffaaf'
        end

        Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
          run_with({
            config_file: File.join('Project', 'Info.plist')
          })
        end
      end

      context 'override API key option' do
        it 'reads API key from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['apiKey']).to eq 'faaffaaffaaffaaffaaffaaffaaffaaf'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              config_file: File.join('Project', 'Info.plist'),
              api_key: 'baobab'
            })
          end
        end

        it 'reads version info from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '2.0-project'
            expect(payload['appBundleVersion']).to eq '6'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            run_with({
              config_file: File.join('Project', 'Info.plist'),
              app_version: '4.0.0',
              ios_bundle_version: '400'
            })
          end
        end
      end
    end
  end
end
