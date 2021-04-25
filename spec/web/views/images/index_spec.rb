RSpec.describe Web::Views::Images::Index do
  let(:exposures) { Hash[images: []] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/images/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #images' do
    expect(view.images).to eq(exposures.fetch(:images))
  end

  context 'when there are no images' do
    it 'shows a placeholder message' do
      expect(rendered).to include('<p class="placeholder">There are no images synced yet.</p>')
    end
  end

  context 'when there are images' do
    let(:image1)     { Image.new(path: '/assets/test_image.png') }
    let(:image2)     { Image.new(path: '/assets/test_image.png') }
    let(:exposures) { Hash[images: [image1, image2]] }

    it 'lists the count' do
      expect(rendered).to include('image count: 2')
    end

    it 'hides the placeholder message' do
      expect(rendered).to_not include('<p class="placeholder">There are no images synced yet.</p>')
    end
  end
end
