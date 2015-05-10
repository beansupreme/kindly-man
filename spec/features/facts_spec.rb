require 'rails_helper'

describe 'using the facts page' do
  it 'allows me to create, update, and delete a fact', js: true do
    visit '/facts'

    click_on 'New Fact...'

    expect(page).to have_content 'Enter a new fact'

    fill_in 'title', with: ''
    fill_in 'subject', with: ''

    click_on 'Save'
    expect(page).to have_content("title can't be blank")
    fill_in 'title', with: 'Earthworms'

    click_on 'Save'

    expect(page).to have_content("subject can't be blank")
    fill_in 'subject', with: 'They come out during rainstorms because it is easy for them to move around'


    click_on 'Save'

    expect(page).to have_content 'Earthworms'
    expect(page).to have_content 'They come out during rainstorms because it is easy for them to move around'

    click_on 'Edit'

    fill_in 'title', with: 'Earthworms love the rain'
    fill_in 'subject', with: ''

    click_on 'Save'

    expect(page).to have_content "subject can't be blank"

    fill_in 'subject', with: 'Rainstorms provide a good opportunity to mate'

    click_on 'Save'

    expect(page).to have_content 'Earthworms love the rain'

    click_on 'Delete'

    expect(page).to_not have_content 'Earthworms love the rain'
  end

  it 'lists all facts, and can search through facts', js: true do
    Fact.create!(title: 'Raindrops', subject: 'Usually only grow to about 9mm in diameter')
    Fact.create!(title: 'bats are cool', subject: 'Bats eat a large number of mosquitos')
    visit '/facts/'

    expect(page).to have_content 'Raindrops'
    expect(page).to have_content 'bats are cool'

    fill_in 'keywords', with: 'bats'
    click_on 'Search'

    expect(page).to have_content 'bats are cool'
  end
end