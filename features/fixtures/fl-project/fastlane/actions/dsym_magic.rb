module Fastlane
  module Actions
    module SharedValues
      DSYM_MAGIC_CUSTOM_VALUE = :DSYM_MAGIC_CUSTOM_VALUE
    end

    class DsymMagicAction < Action
      def self.run(params)
        path = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'dsym3.zip')
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = path
      end

      def self.description
        "Sets the dsym path"
      end

      def self.details
        "Some magic"
      end

      def self.available_options
        []
      end

      def self.output
      end

      def self.return_value
      end

      def self.authors
        ["kattrali"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
