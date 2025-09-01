require 'os'
require 'rbconfig'

class BundledCli
  def self.get_path
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
      else if OS.bits == 64
             self.bin_folder('x86_64-linux-bugsnag-cli')
           else
             self.bin_folder('i386-linux-bugsnag-cli')
           end
      end
    end
  end

  def self.bin_folder(filename)
    File.expand_path("../../../../../bin/#{filename}", File.dirname(__FILE__))
  end
end
