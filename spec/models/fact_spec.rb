require 'rails_helper'

RSpec.describe Fact, type: :model do
  describe 'creating a model' do
    it 'saves the right attributes' do
      fact = Fact.create!(title: 'Patellar Tendonitis', subject: 'Can be treated with ice for 20 minutes')
      expect(fact.id).not_to be_nil
      expect(fact.title).to eq('Patellar Tendonitis')
    end
  end
end