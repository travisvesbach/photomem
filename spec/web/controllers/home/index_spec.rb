RSpec.describe Web::Controllers::Home::Index do
    let(:action) { described_class.new }
    let(:params) { Hash[] }
    let(:imageRepository) { ImageRepository.new }
    let(:directoryRepository) { DirectoryRepository.new }

    before do
      imageRepository.clear
      directoryRepository.clear
      @directory = directoryRepository.create(path: 'test')
      @image = imageRepository.create(directory_id: @directory.id, name: 'test_image.png')
    end

    it 'is successful' do
      response = action.call(params)
      expect(response[0]).to eq(200)
    end

    it 'exposes all images' do
      action.call(params)
      expect(action.exposures[:images]).to eq([@image])
    end
end
