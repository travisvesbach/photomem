RSpec.describe Image, type: :entity do
    it 'can be initialized with attributes' do
        image = Image.new(path: '/assets/test_image.png')
        expect(image.path).to eq('/assets/test_image.png')
    end
end
