RSpec.describe Web::Controllers::Images::Index do
    let(:action) { described_class.new }
    let(:params) { Hash[] }
    let(:repository) { ImageRepository.new }

    before do
      repository.clear

      @image = repository.create(path: '/assets/test_image.png')
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
