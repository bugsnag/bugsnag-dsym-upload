module Fastlane
  module Actions
    class UploadSymbolsToBugsnagAction < Action

      UPLOAD_SCRIPT_PATH = File.expand_path(
        File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'bugsnag-dsym-upload'))

      def self.run(params)
        options = {}
        options = options_from_info_plist(params[:config_file]) if params[:config_file]

        if (params[:config_file] == default_info_plist_path || options[:apiKey].nil? || options[:apiKey].empty?)
          # Load custom API key if config file has not been overridden or the API key couldn't be found in config files
          options[:apiKey] = params[:api_key] unless params[:api_key].nil?
        else
          # Print which file is populating version and API key information since the value has been
          # overridden
          UI.message("Loading API key from #{params[:config_file]}")
        end

        parse_dsym_paths(params[:dsym_path]).each do |dsym_path|
          if dsym_path.end_with?(".zip") or File.directory?(dsym_path)
            args = upload_args(dsym_path, params[:symbol_maps_path], params[:upload_url], params[:project_root], options[:apiKey], params[:verbose])
            success = Kernel.system(UPLOAD_SCRIPT_PATH, *args)
            if success
              UI.success("Uploaded dSYMs in #{dsym_path}")
            else
              UI.user_error!("Failed uploading #{dsym_path}")
            end
          else
            UI.user_error!("The specified symbol file path cannot be used: #{dsym_path}")
          end
        end
      end

      def self.description
        "Uploads symbol files to Bugsnag"
      end

      def self.authors
        ["kattrali"]
      end

      def self.return_value
        nil
      end

      def self.details
        "Takes debug symbol (dSYM) files from a macOS, iOS, or tvOS project and uploads them to Bugsnag to improve stacktrace quality"
      end

      def self.is_supported?(platform)
        [:ios, :mac, :tvos].include?(platform)
      end

      def self.available_options
        validate_dsym_path = proc do |value|
          value.each do |path|
            unless File.exist?(path)
              UI.user_error!("Could not find file at path '#{File.expand_path(path)}'")
            end
            unless File.directory?(path) or path.end_with?(".zip", ".dSYM")
              UI.user_error!("Symbolication file needs to be a directory containing dSYMs, a .dSYM file or a .zip file, got #{File.expand_path(path)}")
            end
          end
        end
        validate_symbol_maps = proc do |path|
          return if path.nil?

          unless File.exist?(path) and File.directory?(path)
            UI.user_error!("Symbol maps file needs to be a directory containing symbol map files")
          end
        end
        validate_api_key = proc do |key|
          return if key.nil?

          unless !key[/\H/] and key.length == 32
            UI.user_error!("API key should be a 32 character hexdeciaml string")
          end
        end

        options = {}
        options = options_from_info_plist(default_info_plist_path) if file_path = default_info_plist_path
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "BUGSNAG_API_KEY",
                                       description: "Bugsnag API Key",
                                       optional: true,
                                       default_value: options[:apiKey],
                                       verify_block: validate_api_key),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       type: Array,
                                       env_name: "BUGSNAG_DSYM_PATH",
                                       description: "Path to the DSYM directory, file, or zip to upload",
                                       default_value: default_dsym_path,
                                       optional: true,
                                       verify_block: validate_dsym_path),
          FastlaneCore::ConfigItem.new(key: :upload_url,
                                       env_name: "BUGSNAG_UPLOAD_URL",
                                       description: "URL of the server receiving uploaded files",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :symbol_maps_path,
                                       env_name: "BUGSNAG_SYMBOL_MAPS_PATH",
                                       description: "Path to the BCSymbolMaps directory to build complete dSYM files",
                                       default_value: nil,
                                       optional: true,
                                       verify_block: validate_symbol_maps),
          FastlaneCore::ConfigItem.new(key: :project_root,
                                       env_name: "BUGSNAG_PROJECT_ROOT",
                                       description: "Root path of the project",
                                       default_value: Dir::pwd,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :config_file,
                                       description: "Info.plist location",
                                       optional: true,
                                       default_value: options[:config_file]),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       env_name: "BUGSNAG_VERBOSE",
                                       description: "Print helpful debug info",
                                       skip_type_validation: true,
                                       optional: true),
        ]
      end

      private

      def self.default_info_plist_path
        Dir.glob("./{ios/,}*/Info.plist").reject {|path| path =~ /build|test/i }.first
      end

      def self.options_from_info_plist file_path
        plist_getter = Fastlane::Actions::GetInfoPlistValueAction
        {
          apiKey: plist_getter.run(path: file_path, key: "BugsnagAPIKey"),
          config_file: file_path,
        }
      end

      def self.upload_args dir, symbol_maps_dir, upload_url, project_root, api_key, verbose
        args = [verbose ? "--verbose" : "--silent"]
        args += ["--api-key", api_key] unless api_key.nil?
        args += ["--upload-server", upload_url] unless upload_url.nil?
        args += ["--symbol-maps", symbol_maps_dir] unless symbol_maps_dir.nil?
        args += ["--project-root", project_root] unless project_root.nil?
        args << dir
        args
      end

      def self.parse_dsym_paths dsym_path
        dsym_paths = dsym_path.is_a?(Array) ? dsym_path : [dsym_path]
        dsym_paths.compact.map do |path|
          path.end_with?(".dSYM") ? File.dirname(path) : path
        end.uniq
      end

      def self.default_dsym_path
        path = Dir["./**/*.dSYM.zip"] + Dir["./**/*.dSYM"]
        dsym_paths = Actions.lane_context[SharedValues::DSYM_PATHS] if defined? SharedValues::DSYM_PATHS
        dsyms_output_path = Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] if defined? SharedValues::DSYM_OUTPUT_PATH
        dsyms_output_path || dsym_paths || path
      end
    end
  end
end
