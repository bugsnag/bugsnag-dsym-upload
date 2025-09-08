require 'os'
require 'rbconfig'

class BugsnagCli
  def self.get_bugsnag_cli_path(params)
    bundled_bugsnag_cli_path = self.get_bundled_path
    bundled_bugsnag_cli_version = Gem::Version.new(`#{bundled_bugsnag_cli_path} --version`.scan(/(?:\d+\.?){3}/).first)

    if params[:bugsnag_cli_path]
      bugsnag_cli_path = params[:bugsnag_cli_path] || bundled_bugsnag_cli_path

      bugsnag_cli_version = Gem::Version.new(`#{bugsnag_cli_path} --version`.scan(/(?:\d+\.?){3}/).first)

      if bugsnag_cli_version < bundled_bugsnag_cli_version
        FastlaneCore::UI.warning("The installed bugsnag-cli at #{bugsnag_cli_path} is outdated (#{bugsnag_cli_version}). The current bundled version is: #{bundled_bugsnag_cli_version}. It is recommended that you either update your installed version or use the bundled version.")
      end
      bugsnag_cli_path
    else
      bundled_bugsnag_cli_path
    end
  end

  def self.get_bundled_path
    host_cpu = RbConfig::CONFIG['host_cpu']
    if OS.mac?
      if host_cpu =~ /arm|aarch64/
        self.bin_folder('arm64-macos-bugsnag-cli')
      else
        self.bin_folder('x86_64-macos-bugsnag-cli')
      end
    elsif OS.windows?
      if OS.bits == 64
        self.bin_folder('x86_64-windows-bugsnag-cli.exe')
      else
        self.bin_folder('i386-windows-bugsnag-cli.exe')
      end
    else
      if host_cpu =~ /arm|aarch64/
        self.bin_folder('arm64-linux-bugsnag-cli')
      elsif OS.bits == 64
        self.bin_folder('x86_64-linux-bugsnag-cli')
      else
        self.bin_folder('i386-linux-bugsnag-cli')
      end
    end
  end

  def self.bin_folder(filename)
    File.expand_path("../../../../../bin/#{filename}", File.dirname(__FILE__))
  end
end
