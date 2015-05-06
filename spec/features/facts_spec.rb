require 'rails_helper'

describe 'hitting the homepage' do
  it 'shows a informative page' do
    visit '/'

    expect(page).to have_content 'What have you learned today?'
  end

  it 'allows me to add a new fact' do
    visit '/facts'

    click_on 'Add a fact'

    expect(page).to have_content 'Enter your new fact'

    fill_in 'fact[title]', with: 'Earthworms'
    fill_in 'fact[subject]', with: 'They come out during rainstorms because it is easy for them to move around'

    click_on 'Save Fact'

    expect(page).to have_content 'Earthworms'
    expect(page).to have_content 'They come out during rainstorms because it is easy for them to move around'
  end

  it 'does not allow filling out a blank fact' do
    visit '/facts/new'

    fill_in 'fact[title]', with: ''
    fill_in 'fact[subject]', with: ''

    click_on 'Save Fact'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Subject can't be blank"
  end

  it 'allows me to update an existing fact' do
    fact = Fact.create!(title: 'Raindrops', subject: 'Usually only grow to about 9mm in diameter')
    visit '/facts/'
    click_on 'Edit Fact'

    fill_in 'fact[title]', with: 'Raindrop size'

    click_on 'Save Fact'

    expect(page).to have_content 'Raindrop size'
  end
end