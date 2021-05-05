RSpec.describe Directory, type: :entity do
    let(:action) { described_class.new }
    let(:params) { Hash[] }
    let(:directoryRepository) { DirectoryRepository.new }

    before do
      directoryRepository.clear
    end

    it 'can be initialized with attributes' do
        directory = directoryRepository.create(path: 'test')
        expect(directory.path).to eq('test')
        expect(directory.status).to eq('unsynced')
    end
end
