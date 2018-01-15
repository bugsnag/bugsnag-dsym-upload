require 'spec_helper'

Action = Fastlane::Actions::UploadSymbolsToBugsnagAction

FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

describe Action do

  it 'has an executable upload script' do
    expect(File.exist?(Action::UPLOAD_SCRIPT_PATH)).to be true
  end

  describe '#run' do
    it 'silences script output by default' do
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", FIXTURE_PATH)
      Action.run({dsym_path: FIXTURE_PATH})
    end

    it 'requires the dSYM file path to exist' do
      expect(Fastlane::UI).to receive(:user_error!)

      Action.run({dsym_path: 'fake/file/path'})
    end

    it 'rejects dSYM files which are not a .zip or a directory' do
      expect(Fastlane::UI).to receive(:user_error!)

      Action.run({dsym_path: File.join(FIXTURE_PATH, 'invalid_file')})
    end

    it 'uploads a single .dSYM file' do
      directory = File.join(FIXTURE_PATH, 'dSYMs')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", directory)
      Action.run({dsym_path: File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')})
    end

    it 'uploads a .zip of .dSYM files' do
      path = File.join(FIXTURE_PATH, 'files.zip')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", path)
      Action.run({dsym_path: path})
    end

    it 'uploads multiple .zip files' do
      zip1 = File.join(FIXTURE_PATH, 'files.zip')
      zip2 = File.join(FIXTURE_PATH, 'more_files.zip')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", zip1)
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", zip2)
      Action.run({dsym_path: [zip1, zip2]})
    end

    it 'uploads multiple .dSYM files multiple directories' do
      dsym1 = File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')
      dsym2 = File.join(FIXTURE_PATH, 'stuff/app.dSYM')
      dsym3 = File.join(FIXTURE_PATH, 'dSYMs/app2.dSYM')
      dsym4 = File.join(FIXTURE_PATH, 'stuff/app2.dSYM')
      directories = [File.join(FIXTURE_PATH, 'dSYMs'), File.join(FIXTURE_PATH, 'stuff')]
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", directories[0])
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", directories[1])
      Action.run({dsym_path: [dsym1, dsym2, dsym3, dsym4]})
    end

    it 'uploads multiple .dSYM files in a single directory' do
      dsym1 = File.join(FIXTURE_PATH, 'dSYMs/app.dSYM')
      dsym2 = File.join(FIXTURE_PATH, 'dSYMs/app2.dSYM')
      directory = File.join(FIXTURE_PATH, 'dSYMs')
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent", directory)
      Action.run({dsym_path: [dsym1, dsym2]})
    end

    it 'accepts a project root argument' do
      root_path = "/test/test/test"
      expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                              "--silent",
                                              "--project-root", root_path,
                                              FIXTURE_PATH)
      Action.run({dsym_path: FIXTURE_PATH, project_root: root_path})
    end

    context 'using a private server' do
      it 'uploads to the private server' do
        expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                                "--silent",
                                                "--upload-server", "http://myserver.example.com",
                                                FIXTURE_PATH)
        Action.run({dsym_path: FIXTURE_PATH,
                    upload_url: "http://myserver.example.com"})
      end
    end

    context 'using bitcode' do
      it 'combines dSYM files with symbols' do
        path = File.join(FIXTURE_PATH, 'BCSymbolMaps')
        expect(Kernel).to receive(:system).with(Action::UPLOAD_SCRIPT_PATH,
                                                "--silent",
                                                "--symbol-maps", path,
                                                FIXTURE_PATH)
        Action.run({dsym_path: FIXTURE_PATH, symbol_maps_path: path})
      end
    end
  end
end
