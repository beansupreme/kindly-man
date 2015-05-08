require 'rails_helper'

feature 'Viewing a fact', js: true do
  before do
    Fact.create!(title: 'Brighton', subject: 'Is in South England')
    Fact.create!(title: 'British Parliament', subject: 'Can form a coalition govt')
  end

  scenario 'viewing one fact' do
    visit '/'
    fill_in 'keywords', with: 'Bri'
    click_on 'Search'

    click_on 'British Parliament'

    expect(page).to have_content 'British Parliament'
    expect(page).to have_content 'Can form a coalition govt'

    click_on 'Back'
    
    expect(page).to have_content 'British Parliament'
    expect(page).to_not have_content 'Can form a coalition govt'
  end
end