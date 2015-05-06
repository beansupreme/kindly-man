require 'rails_helper'

describe 'hitting the homepage' do
  it 'shows a informative page' do
    visit '/'

    expect(page).to have_content 'What have you learned today?'
  end
end