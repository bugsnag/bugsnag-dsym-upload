require "xmlsimple"
require "json"

module Fastlane
  module Actions
    class BugsnagNotifyBuildAction < Action

      BUILD_TOOL = "bugsnag-fastlane-plugin"

      def self.run(params)
        payload = {buildTool: BUILD_TOOL, sourceControl: {}}
        if lane_context[:PLATFORM_NAME] == :android
          payload.merge!(options_from_android_manifest(params[:config_file])) if params[:config_file]
        else
          payload.merge!(options_from_info_plist(params[:config_file])) if params[:config_file]
        end
        payload.delete(:config_file)

        # Overwrite automated options with configured if set
        payload[:apiKey] = params[:api_key] unless params[:api_key].nil?
        payload[:appVersion] = params[:app_version] unless params[:app_version].nil?
        payload[:releaseStage] = params[:release_stage] unless params[:release_stage].nil?
        payload[:appVersionCode] = params[:android_version_code] unless params[:android_version_code].nil?
        payload[:appBundleVersion] = params[:ios_bundle_version] unless params[:ios_bundle_version].nil?
        payload[:builderName] = params[:builder]

        payload[:sourceControl][:revision] = params[:revision] if params[:revision]
        payload[:sourceControl][:repository] = params[:repository] if params[:repository]

        payload.reject! {|k,v| v == nil || (v.is_a?(Hash) && v.empty?)}

        if payload[:apiKey].nil? || !payload[:apiKey].is_a?(String)
          UI.user_error! missing_api_key_message(params)
        end
        if payload[:appVersion].nil?
          UI.user_error! missing_api_key_message(params)
        end
        send_notification(params[:endpoint], ::JSON.dump(payload))
      end

      def self.missing_api_key_message(params)
        message = "A Bugsnag API key is required to release a build. "
        if lane_context[:PLATFORM_NAME] == :android
          if params[:config_file]
            message << "Set com.bugsnag.android.API_KEY in your AndroidManifest.xml to detect API key automatically."
          else
            message << "Set the config_file option with the path to your AndroidManifest.xml and set com.bugsnag.android.API_KEY in it to detect API key automatically."
          end
        else
          if params[:config_file]
            message << "Set BugsnagAPIKey in your Info.plist file to detect API key automatically."
          else
            message << "Set the config_file option with the path to your Info.plist and set BugsnagAPIKey in it to detect API key automatically."
          end
        end
        message
      end

      def self.missing_app_version_message(params)
        message = "An app version must be specified release a build."
        if lane_context[:PLATFORM_NAME] == :android
          if params[:config_file]
            message << "Set com.bugsnag.android.APP_VERSION in your AndroidManifest.xml to detect this value automatically."
          else
            message << "Set the config_file option with the path to your AndroidManifest.xml and set com.bugsnag.android.APP_VERSION in it to detect this value automatically."
          end
        else
          if params[:config_file]
            message << "Set the app_version option with your app version or set config_file to update the path to your Info.plist"
          else
            message << "Set the config_file option with the path to your Info.plist"
          end
        end
        message
      end

      def self.description
        "Notifies Bugsnag of a build"
      end

      def self.authors
        ["cawllec"]
      end

      def self.example_code
        ['bugsnag_notify_build']
      end

      def self.category
        :building
      end

      def self.return_value
        nil
      end

      def self.details
        "Notifies Bugsnag of a new build being released including app version and source control details"
      end

      def self.is_supported?(platform)
        [:ios, :mac, :android].include?(platform)
      end

      def self.available_options
        options = load_default_values
        [
          FastlaneCore::ConfigItem.new(key: :config_file,
                                       description: "AndroidManifest.xml/Info.plist location",
                                       optional: true,
                                       default_value: options[:config_file]),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       description: "Bugsnag API Key",
                                       optional: true,
                                       default_value: options[:apiKey]),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                       description: "App version being built",
                                       optional: true,
                                       default_value: options[:appVersion]),
          FastlaneCore::ConfigItem.new(key: :android_version_code,
                                       description: "Android app version code",
                                       optional: true,
                                       default_value: options[:appVersionCode]),
          FastlaneCore::ConfigItem.new(key: :ios_bundle_version,
                                       description: "iOS/macOS/tvOS bundle version",
                                       optional: true,
                                       default_value: options[:appBundleVersion]),
          FastlaneCore::ConfigItem.new(key: :release_stage,
                                       description: "Release stage being built, i.e. staging, production",
                                       optional: true,
                                       default_value: options[:releaseStage] || "production"),
          FastlaneCore::ConfigItem.new(key: :builder,
                                       description: "The name of the entity triggering the build",
                                       optional: true,
                                       default_value: `whoami`.chomp),
          FastlaneCore::ConfigItem.new(key: :repository,
                                       description: "The source control repository URL for this application",
                                       optional: true,
                                       default_value: options[:repository]),
          FastlaneCore::ConfigItem.new(key: :revision,
                                       description: "The source control revision id",
                                       optional: true,
                                       default_value: options[:revision]),
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       description: "Bugsnag deployment endpoint",
                                       optional: true,
                                       default_value: "https://build.bugsnag.com")
        ]
      end

      private

      def self.load_default_values
        options = {releaseStage: "production", user: `whoami`.chomp}
        if file_path = default_android_manifest_path
          options.merge!(options_from_android_manifest(file_path))
          build_gradle_path = Dir.glob("app/build.gradle").first
          build_gradle_path ||= Dir.glob("build.gradle")
          options.merge!(options_from_build_gradle(build_gradle_path)) if build_gradle_path
        elsif file_path = default_info_plist_path
          options.merge!(options_from_info_plist(file_path))
        end
        if git_opts = git_remote_options
          options.merge!(git_opts)
        end
        options
      end

      def self.default_android_manifest_path
        Dir.glob("./{app,}/src/main/AndroidManifest.xml").first
      end

      def self.default_info_plist_path
        Dir.glob("./*/Info.plist").first
      end

      def self.options_from_info_plist file_path
        plist_getter = Fastlane::Actions::GetInfoPlistValueAction
        {
          apiKey: plist_getter.run(path: file_path, key: "BugsnagAPIKey"),
          appVersion: plist_getter.run(path: file_path, key: "CFBundleShortVersionString"),
          appBundleVersion: plist_getter.run(path: file_path, key: "CFBundleVersion"),
          config_file: file_path,
        }
      end

      def self.options_from_android_manifest file_path
        options = {}
        begin
          meta_data = parse_android_manifest_options(XmlSimple.xml_in(file_path))

          options[:apiKey] = meta_data["com.bugsnag.android.API_KEY"]
          options[:appVersion] = meta_data["com.bugsnag.android.APP_VERSION"]
          options[:releaseStage] = meta_data["com.bugsnag.android.RELEASE_STAGE"]
        rescue ArgumentError
          nil
        end
        options[:config_file] = file_path
        options
      end

      def self.options_from_build_gradle file_path
        options = {}
        begin
          content = File.read(file_path)
          if content =~ /versionCode (\d+)/
            options[:appVersionCode] = $1
          end
          if content =~ /versionName \W(.*)\W[\s]*\n/
            options[:appVersion] = $1
          end
        rescue
        end
        options
      end

      def self.git_remote_options
        require "git"
        begin
          repo = Git.open(Dir.pwd)
          origin = repo.remotes.detect {|r| r.name == "origin"}
          origin = repo.remotes.first unless origin
          if origin
            return {
              repository: origin.url,
              revision: repo.revparse("HEAD"),
            }
          end
        rescue
        end
        nil
      end

      def self.parse_android_manifest_options config_hash
        map_meta_data(get_meta_data(config_hash))
      end

      def self.get_meta_data(object, output = [])
        if object.is_a?(Array)
          object.each do |item|
            output = get_meta_data(item, output)
          end
        elsif object.is_a?(Hash)
          object.each do |key, value|
            if key === "meta-data"
              output << value
            elsif value.is_a?(Array) || value.is_a?(Hash)
              output = get_meta_data(value, output)
            end
          end
        end
        output.flatten
      end

      def self.map_meta_data(meta_data)
        output = {}
        meta_data.each do |hash|
          output[hash["android:name"]] = hash["android:value"]
        end
        output
      end

      def self.send_notification(url, body)
        require "net/http"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 15
        http.open_timeout = 15

        http.use_ssl = uri.scheme == "https"

        uri.path == "" ? "/" : uri.path
        request = Net::HTTP::Post.new(uri, {"Content-Type" => "application/json"})
        request.body = body
        http.request(request)
        UI.say "Build notification sent to Bugsnag"
      end
    end
  end
end
