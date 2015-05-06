require 'rails_helper'

describe 'hitting the homepage' do
  it 'shows a informative page' do
    visit '/'

    expect(page).to have_content 'What have you learned today?'
  end

  it 'allows me to add a new fact' do
    visit '/'

    click_on 'Add a fact'

    expect(page).to have_content 'Enter your new fact'

    fill_in 'fact[title]', with: 'Earthworms'
    fill_in 'fact[subject]', with: 'They come out during rainstorms because it is easy for them to move around'

    click_on 'Save Fact'

    expect(page).to have_content 'Earthworms'
    expect(page).to have_content 'They come out during rainstorms because it is easy for them to move around'
  end
end