require 'rails_helper'

describe FactsController do
  describe '#index' do
    it 'returns 200' do
      get :index
      expect(response.code).to eq('200')
    end
  end

  describe '#new' do
    it 'returns 200' do
      get :new
      expect(response.code).to eq('200')
    end
  end

  describe '#create' do
    it 'can create a new fact' do
      post :create, fact: {title: 'Kombucha', subject: 'Has scoby'}
      expect(response.code).to eq('200')
      expect(assigns(@fact)).to_not be_nil
    end
  end
end