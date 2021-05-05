require 'features_helper'

RSpec.describe 'List image details' do
    it 'displays synced image details on the page' do
        visit '/'

        expect(page).to have_content('Synced image count:')
        expect(page).to have_content('Images taken this day in history:')
    end
end
