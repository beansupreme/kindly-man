require 'rails_helper'

RSpec.describe Fact, type: :model do
  describe 'validations' do
    it 'validates title' do
      invalid_fact = Fact.create(title: '', subject: 'foo')
      expect(invalid_fact.errors[:title]).to include("can't be blank")
    end

    it 'validates subject' do
      invalid_fact = Fact.create(title: 'bar', subject: '')
      expect(invalid_fact.errors[:subject]).to include("can't be blank")
    end
  end

  describe 'creating a model' do
    it 'saves the right attributes' do
      fact = Fact.create!(title: 'Patellar Tendonitis', subject: 'Can be treated with ice for 20 minutes')
      expect(fact.id).not_to be_nil
      expect(fact.title).to eq('Patellar Tendonitis')
    end
  end
end