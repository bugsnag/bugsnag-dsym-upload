require "xmlsimple"
require "json"

module Fastlane
  module Actions
    class SendBuildToBugsnagAction < Action

      BUILD_TOOL = "bugsnag-fastlane-plugin"

      def self.run(params)
        payload = {buildTool: BUILD_TOOL, sourceControl: {}}

        # If a configuration file was found or was specified, load in the options:
        if params[:config_file]
          UI.message("Loading build information from #{params[:config_file]}")
          config_options = load_config_file_options(params[:config_file])

          # for each of the config options, if it's not been overriden by any
          # input to the lane, write it to the payload:
          payload[:apiKey] = params[:api_key] || config_options[:apiKey]
          payload[:appVersion] = params[:app_version] || config_options[:appVersion]
          payload[:appVersionCode] = params[:android_version_code] || config_options[:appVersionCode]
          payload[:appBundleVersion] = params[:ios_bundle_version] || config_options[:appBundleVersion]
          payload[:releaseStage] = params[:release_stage] || config_options[:releaseStage] || "production"
        else
          # No configuration file was found or specified, use the input parameters:
          payload[:apiKey] = params[:api_key]
          payload[:appVersion] = params[:app_version]
          payload[:appVersionCode] = params[:android_version_code]
          payload[:appBundleVersion] = params[:ios_bundle_version]
          payload[:releaseStage] = params[:release_stage] || "production"
        end

        # If builder, or source control information has been provided into
        # Fastlane, apply it to the payload here.
        payload[:builderName] = params[:builder] if params[:builder]
        payload[:sourceControl][:revision] = params[:revision] if params[:revision]
        payload[:sourceControl][:repository] = params[:repository] if params[:repository]
        payload[:sourceControl][:provider] = params[:provider] if params[:provider]

        payload.reject! {|k,v| v == nil || (v.is_a?(Hash) && v.empty?)}

        if payload[:apiKey].nil? || !payload[:apiKey].is_a?(String)
          UI.user_error! missing_api_key_message(params)
        end
        if payload[:appVersion].nil?
          UI.user_error! missing_app_version_message(params)
        end

        # If verbose flag is enabled (`--verbose`), display the payload debug info
        UI.verbose("Sending build to Bugsnag with payload:")
        payload.each do |param|
          UI.verbose("  #{param[0].to_s.rjust(18)}: #{param[1]}")
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
            message << "Set bugsnag.apiKey in your Info.plist file to detect API key automatically."
          else
            message << "Set the config_file option with the path to your Info.plist and set bugsnag.apiKey in it to detect API key automatically."
          end
        end
        message
      end

      def self.missing_app_version_message(params)
        message = "An app version must be specified release a build. "
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
        ['send_build_to_bugsnag']
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
        git_options = load_git_remote_options
        [
          FastlaneCore::ConfigItem.new(key: :config_file,
                                       description: "AndroidManifest.xml/Info.plist location",
                                       optional: true,
                                       default_value: default_config_file_path),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       description: "Bugsnag API Key",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                       description: "App version being built",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :android_version_code,
                                       description: "Android app version code",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :ios_bundle_version,
                                       description: "iOS/macOS/tvOS bundle version",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :release_stage,
                                       description: "Release stage being built, i.e. staging, production",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :builder,
                                       description: "The name of the entity triggering the build",
                                       optional: true,
                                       default_value: `whoami`.chomp),
          FastlaneCore::ConfigItem.new(key: :repository,
                                       description: "The source control repository URL for this application",
                                       optional: true,
                                       default_value: git_options[:repository]),
          FastlaneCore::ConfigItem.new(key: :revision,
                                       description: "The source control revision id",
                                       optional: true,
                                       default_value: git_options[:revision]),
          FastlaneCore::ConfigItem.new(key: :provider,
                                       description: "The source control provider, one of 'github-enterprise', 'gitlab-onpremise', or 'bitbucket-server', if any",
                                       optional: true,
                                       default_value: nil,
                                       verify_block: proc do |value|
                                         valid = ['github', 'github-enterprise', 'gitlab', 'gitlab-onpremise', 'bitbucket', 'bitbucket-server'].include? value
                                         unless valid
                                           UI.user_error!("Provider must be one of 'github', 'github-enterprise', 'gitlab', 'gitlab-onpremise', 'bitbucket', 'bitbucket-server', or unspecified")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       description: "Bugsnag deployment endpoint",
                                       optional: true,
                                       default_value: "https://build.bugsnag.com")
        ]
      end

      private

      # Get any Git options (remote repo, and revision) from the directory
      def self.load_git_remote_options
        git_options = {repository:nil, revision:nil}
        require "git"
        begin
          repo = Git.open(Dir.pwd)
          origin = repo.remotes.detect {|r| r.name == "origin"}
          origin = repo.remotes.first unless origin
          if origin
            git_options[:repository] = origin.url
            git_options[:revision] = repo.revparse("HEAD")
          end
        rescue
        end
        return git_options
      end

      # Used to get a default configuration file (AndroidManifest.xml or Info.plist)
      def self.default_config_file_path
        case lane_context[:PLATFORM_NAME]
        when nil
          if file_path = default_android_manifest_path
            return file_path
          elsif file_path = default_info_plist_path
            return file_path
          end
        when :android
          if file_path = default_android_manifest_path
            return file_path
          end
        else
          if file_path = default_info_plist_path
            return file_path
          end
        end
      end

      def self.load_config_file_options config_file
        options = {}
        case File.extname(config_file)
        when ".xml"
          options = load_options_from_xml(config_file)
          return options
        when ".plist"
          options = load_options_from_plist(config_file)
          return options
        else
          UI.user_error("File type of '#{config_file}' was not recognised. This should be .xml for Android and .plist for Cococa")
        end
      end

      def self.default_info_plist_path
        Dir.glob("./{ios/,}*/Info.plist").reject {|path| path =~ /build|test/i }.sort.first
      end

      def self.load_options_from_plist file_path
        options = {}
        plist_getter = Fastlane::Actions::GetInfoPlistValueAction
        bugsnag_dict = plist_getter.run(path: file_path, key: "bugsnag")
        api_key = bugsnag_dict["apiKey"] unless bugsnag_dict.nil?
        release_stage = bugsnag_dict["releaseStage"] unless bugsnag_dict.nil?
        if api_key.nil?
          api_key = plist_getter.run(path: file_path, key: "BugsnagAPIKey")
        end
        options[:apiKey] = api_key
        options[:releaseStage] = release_stage
        options[:appVersion] = plist_getter.run(path: file_path, key: "CFBundleShortVersionString")
        options[:appBundleVersion] = plist_getter.run(path: file_path, key: "CFBundleVersion")
        return options
      end

      def self.default_android_manifest_path
        Dir.glob("./{android/,}{app,}/src/main/AndroidManifest.xml").sort.first
      end

      def self.load_options_from_xml file_path
        options = options_from_android_manifest(file_path)
        build_gradle_path = Dir.glob("{android/,}app/build.gradle").sort.first || Dir.glob("build.gradle").sort.first
        options.merge!(options_from_build_gradle(build_gradle_path)) if build_gradle_path
        return options
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

      def self.parse_response_body(response)
        begin
          JSON.load(response.body)
        rescue
          nil
        end
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
        begin
          response = http.request(request)
        rescue => e
          UI.user_error! "Failed to notify Bugsnag of a new build: #{e}"
        end
        if body = parse_response_body(response)
          if body.has_key? "errors"
            errors = body["errors"].map {|error| "\n  * #{error}"}.join
            UI.user_error! "The following errors occurred while notifying Bugsnag:#{errors}.\n\nPlease update your lane config and retry."
          elsif response.code != "200"
            UI.user_error! "Failed to notify Bugsnag of a new build. Please retry. HTTP status code: #{response.code}"
          end
          if body.has_key? "warnings"
            warnings = body["warnings"].map {|warn| "\n  * #{warn}"}.join
            UI.important "Sending the build to Bugsnag succeeded with the following warnings:#{warnings}\n\nPlease update your lane config."
          end
        end
      end
    end
  end
end
