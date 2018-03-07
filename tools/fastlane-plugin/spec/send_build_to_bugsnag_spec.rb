require 'spec_helper'
require 'json'
require 'fastlane/actions/get_info_plist_value'

BuildAction = Fastlane::Actions::SendBuildToBugsnagAction

FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

describe BuildAction do
  def load_default_opts
    BuildAction.available_options.map do |x|
      [x.key, x.default_value]
    end.to_h
  end

  context 'building an iOS project' do
    it 'detects default Info.plist file excluding test dirs' do
      expect(BuildAction).to receive(:send_notification) do |url, body|
        payload = ::JSON.load(body)
        expect(payload['appVersion']).to eq '3.0-other'
        expect(payload['appBundleVersion']).to eq '56'
        expect(payload['apiKey']).to eq 'other-key'
      end

      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
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
            BuildAction.run(load_default_opts.merge({
              api_key: 'baobab'
            }))
          end
        end

        it 'reads version info from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '4.0.0'
            expect(payload['appBundleVersion']).to eq '400'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            BuildAction.run(load_default_opts.merge({
              app_version: '4.0.0',
              ios_bundle_version: '400'
            }))
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
          expect(payload['apiKey']).to eq 'project-key'
        end

        Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
          BuildAction.run(load_default_opts.merge({
            config_file: File.join('Project', 'Info.plist')
          }))
        end
      end

      context 'override API key option' do
        it 'reads API key from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['apiKey']).to eq 'project-key'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            BuildAction.run(load_default_opts.merge({
              config_file: File.join('Project', 'Info.plist'),
              api_key: 'baobab'
            }))
          end
        end

        it 'reads version info from the config file' do
          expect(BuildAction).to receive(:send_notification) do |url, body|
            payload = ::JSON.load(body)
            expect(payload['appVersion']).to eq '2.0-project'
            expect(payload['appBundleVersion']).to eq '6'
          end

          Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
            BuildAction.run(load_default_opts.merge({
              config_file: File.join('Project', 'Info.plist'),
              app_version: '4.0.0',
              ios_bundle_version: '400'
            }))
          end
        end
      end
    end
  end
end
