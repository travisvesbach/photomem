require 'features_helper'

RSpec.describe 'List image details' do
    it 'displays synced image details on the page' do
        visit '/images'

        expect(page).to have_content('Synced Image Details')
    end
end
