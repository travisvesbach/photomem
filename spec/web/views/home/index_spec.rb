RSpec.describe Web::Views::Home::Index, type: :view do
  let(:exposures) { Hash[images: [], today: []] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/home/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #images' do
    expect(view.images).to eq(exposures.fetch(:images))
  end

  it 'exposes #today' do
    expect(view.images).to eq(exposures.fetch(:today))
  end

  context 'when there are no images' do
    it 'shows a placeholder message' do
      expect(rendered).to include('There are no images synced yet.')
    end
  end

  context 'when there are images' do
    let(:image1)     { Image.new(name: 'test_image.png') }
    let(:image2)     { Image.new(name: 'test_image2.png') }
    let(:exposures) { Hash[images: [image1, image2], today: []] }

    it 'lists the count' do
      expect(rendered).to include('image count: 2')
    end

    it 'hides the placeholder message' do
      expect(rendered).to_not include('There are no images synced yet.')
    end
  end
end
