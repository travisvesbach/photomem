RSpec.describe Image, type: :entity do
    let(:action) { described_class.new }
    let(:params) { Hash[] }
    let(:imageRepository) { ImageRepository.new }
    let(:directoryRepository) { DirectoryRepository.new }

    before do
      imageRepository.clear
      directoryRepository.clear
    end

    it 'can be initialized with attributes' do
        directory = DirectoryRepository.new.create(path: 'test')
        image = Image.new(directory_id: directory.id, name: 'test_image.png')
        expect(image.path).to eq('./public/assets/sync/test/test_image.png')
    end
end
