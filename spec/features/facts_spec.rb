require 'rails_helper'

describe 'using the facts page' do
  let!(:fact) { Fact.create!(title: 'Raindrops', subject: 'Usually only grow to about 9mm in diameter') }

  xit 'shows a informative home page listing the existing facts' do
    visit '/'

    expect(page).to have_content 'What have you learned today?'
    expect(page).to have_content 'Raindrops'
    expect(page).to have_content 'Usually only grow to about 9mm in diameter'
  end

  xit 'can add a new fact' do
    visit '/facts'

    click_on 'Add a fact'

    expect(page).to have_content 'Enter your new fact'

    fill_in 'fact[title]', with: 'Earthworms'
    fill_in 'fact[subject]', with: 'They come out during rainstorms because it is easy for them to move around'

    click_on 'Create Fact'

    expect(page).to have_content 'Earthworms'
    expect(page).to have_content 'They come out during rainstorms because it is easy for them to move around'
  end

  xit 'does not allow filling out a blank fact' do
    visit '/facts/new'

    fill_in 'fact[title]', with: ''
    fill_in 'fact[subject]', with: ''

    click_on 'Create Fact'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Subject can't be blank"
  end

  xit 'can update an existing fact' do
    visit '/facts/'
    click_on 'Edit Fact'

    fill_in 'fact[title]', with: 'Raindrop size'

    click_on 'Update Fact'

    expect(page).to have_content 'Raindrop size'
  end

  xit 'can destroy an existing fact' do
    visit '/facts/'
    click_on 'Destroy Fact'

    expect(page).to_not have_content 'Raindrops'
  end

  it 'can search through facts', js: true do
    Fact.create!(title: 'bats are cool', subject: 'Bats eat a large number of mosquitos')
    visit '/facts/'

    fill_in 'keywords', with: 'bats'
    click_on 'Search'

    expect(page).to have_content 'bats are cool'
  end
end