require 'spec_helper'

Action = Fastlane::Actions::UploadSymbolsToBugsnagAction

describe Action do
  def run_with args
    Action.run(Fastlane::ConfigurationHelper.parse(Action, args))
  end

  context "the packaged gem" do
    gem_name = "fastlane-plugin-bugsnag-#{Fastlane::Bugsnag::VERSION}"

    after do
      FileUtils.rm_rf(gem_name)
      FileUtils.rm_rf("#{gem_name}.gem")
    end

    it 'has an executable upload script' do
      system('rake build')
      system("gem unpack #{gem_name}.gem")
      expect(File.exist?(File.join("#{gem_name}/bugsnag-dsym-upload"))).to be true
    end
  end

  describe '#run' do
    it 'silences script output by default' do
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", 
                                              "--project-root", Dir::pwd,
                                              FIXTURE_PATH).and_return(true)
      run_with({dsym_path: FIXTURE_PATH})
    end

    it 'prints verbose if verbose flag set' do
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--verbose", 
                                              "--project-root", Dir::pwd,
                                              FIXTURE_PATH).and_return(true)
      run_with({dsym_path: FIXTURE_PATH, verbose: true})
    end

    it 'UI.user_error when script fails' do
      expect(Fastlane::UI).to receive(:user_error!).with("Failed uploading #{FIXTURE_PATH}")
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
        "--silent", "--project-root", Dir::pwd, FIXTURE_PATH).and_return(false)
      run_with({dsym_path: FIXTURE_PATH})
    end

    it 'requires the dSYM file path to exist' do
      expect(Fastlane::UI).to receive(:user_error!)

      run_with({dsym_path: 'fake/file/path'})
    end

    it 'rejects dSYM files which are not a .zip or a directory' do
      expect(Fastlane::UI).to receive(:user_error!)

      run_with({dsym_path: File.join(FIXTURE_PATH, 'invalid_file')})
    end

    it 'uploads a single .dSYM file' do
      directory = File.join(FIXTURE_PATH, 'dSYMs')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, directory).and_return(true)
      run_with({dsym_path: File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')})
    end

    it 'uploads a .zip of .dSYM files' do
      path = File.join(FIXTURE_PATH, 'files.zip')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, path).and_return(true)
      run_with({dsym_path: path})
    end

    it 'uploads multiple .zip files' do
      zip1 = File.join(FIXTURE_PATH, 'files.zip')
      zip2 = File.join(FIXTURE_PATH, 'more_files.zip')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, zip1).and_return(true)
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, zip2).and_return(true)
      run_with({dsym_path: [zip1, zip2]})
    end

    it 'uploads multiple .dSYM files multiple directories' do
      dsym1 = File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')
      dsym2 = File.join(FIXTURE_PATH, 'stuff/app.dSYM')
      dsym3 = File.join(FIXTURE_PATH, 'dSYMs/app2.dSYM')
      dsym4 = File.join(FIXTURE_PATH, 'stuff/app2.dSYM')
      directories = [File.join(FIXTURE_PATH, 'dSYMs'), File.join(FIXTURE_PATH, 'stuff')]
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, directories[0]).and_return(true)
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, directories[1]).and_return(true)
      run_with({dsym_path: [dsym1, dsym2, dsym3, dsym4]})
    end

    it 'uploads multiple .dSYM files in a single directory' do
      dsym1 = File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')
      dsym2 = File.join(FIXTURE_PATH, 'dSYMs/app2.dSYM')
      directory = File.join(FIXTURE_PATH, 'dSYMs')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", "--project-root", Dir::pwd, directory).and_return(true)
      run_with({dsym_path: [dsym1, dsym2]})
    end

    it 'accepts a project root argument' do
      root_path = "/test/test/test"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--project-root", root_path,
                                              FIXTURE_PATH).and_return(true)
      run_with({dsym_path: FIXTURE_PATH, project_root: root_path})
    end

    it 'accepts an API key argument' do
      api_key = "123456789123456789001234567890FF"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--api-key", api_key,
                                              "--project-root", Dir::pwd,
                                              FIXTURE_PATH).and_return(true)
      run_with({dsym_path: FIXTURE_PATH, api_key: api_key})
    end

    it 'accepts an API key argument with no project root' do
      api_key = "123456789012345678901234567890FF"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--api-key", api_key,
                                              "--project-root", `pwd`.chomp,
                                              FIXTURE_PATH).and_return(true)
      run_with({dsym_path: FIXTURE_PATH, api_key: api_key, project_root: nil})
    end

    it 'uses default API key argument from plist' do
      root_path = "/test/test/test"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--api-key", "3443f00f3443f00f3443f00f3443f00f",
                                              "--project-root", root_path,
                                              FIXTURE_PATH).and_return(true)
      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
        run_with({dsym_path: FIXTURE_PATH, project_root: root_path})
      end
    end
    
    it 'allows config file to overwrite parameter' do
      api_key = "123456789123456789001234567890FF"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--api-key", "faaffaaffaaffaaffaaffaaffaaffaaf",
                                              "--project-root", File.join(FIXTURE_PATH, 'ios_proj'),
                                              FIXTURE_PATH).and_return(true)
      Dir.chdir(File.join(FIXTURE_PATH, 'ios_proj')) do
        run_with({dsym_path: FIXTURE_PATH, api_key: api_key, config_file: File.join('Project', 'Info.plist')})
      end
    end

    context 'using a private server' do
      it 'uploads to the private server' do
        expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                                "--silent",
                                                "--upload-server", "http://myserver.example.com",
                                                "--project-root", Dir::pwd,
                                                FIXTURE_PATH).and_return(true)
        run_with({dsym_path: FIXTURE_PATH, upload_url: "http://myserver.example.com"})
      end
    end

    context 'using bitcode' do
      it 'combines dSYM files with symbols' do
        path = File.join(FIXTURE_PATH, 'BCSymbolMaps')
        expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                                "--silent",
                                                "--symbol-maps", path,
                                                "--project-root", Dir::pwd,
                                                FIXTURE_PATH).and_return(true)
        run_with({dsym_path: FIXTURE_PATH, symbol_maps_path: path})
      end
    end
  end
end
