module Fastlane
  module Actions
    class UploadSymbolsToBugsnagAction < Action

      UPLOAD_SCRIPT_PATH = File.expand_path(
        File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', 'bugsnag-dsym-upload'))

      def self.run(params)
        parse_dsym_paths(params[:dsym_path]).each do |dsym_path|
          if dsym_path.end_with?(".zip") or File.directory?(dsym_path)
            args = upload_args(dsym_path, params[:symbol_maps_path], params[:upload_url], params[:project_root], params[:verbose])
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
          value = [value] unless value.is_a? Array
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
        [
          FastlaneCore::ConfigItem.new(key: :dsym_path,
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
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       env_name: "BUGSNAG_VERBOSE",
                                       description: "Print helpful debug info",
                                       skip_type_validation: true,
                                       optional: true),
        ]
      end

      private

      def self.upload_args dir, symbol_maps_dir, upload_url, project_root, verbose
        args = [verbose ? "--verbose" : "--silent"]
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
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] ||
          Actions.lane_context[SharedValues::DSYM_PATHS] ||
          Dir["./**/*.dSYM.zip"] + Dir["./**/*.dSYM"]
      end
    end
  end
end
