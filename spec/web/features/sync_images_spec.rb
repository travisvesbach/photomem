require 'features_helper'

RSpec.describe 'Index Images' do
    it 'indexes images in the assets directory' do
        visit '/images/sync'

        expect(page).to have_content('Synced Image Details')
    end
end
