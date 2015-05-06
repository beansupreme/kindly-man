require 'rails_helper'

describe FactsController do
  describe '#index' do
    it 'returns 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'assigns all of the facts' do
      vietnam_fact = Fact.create!(title: 'Saigon', subject: 'Was evacuated in April 1975')
      cambodia_fact = Fact.create!(title: 'Cambodia', subject: 'Cooperated with North Vietnamese soldiers')
      get :index

      expect(assigns(:facts)).to match_array([vietnam_fact, cambodia_fact])
    end
  end

  describe '#new' do
    it 'returns 200' do
      get :new
      expect(response.code).to eq('200')
    end

    it 'initializes a fact' do
      get :new
      expect(assigns(:fact)).to be_a(Fact)
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'can create a new fact' do
        fact_params = {title: 'Kombucha', subject: 'Has scoby'}
        expect(Fact).to receive(:new).with(fact_params).and_return(Fact.new)
        post :create, fact: fact_params
      end

      it 'redirects to the fact path' do
        post :create, fact: {title: 'Tendonitis', subject: 'is annoying'}
        expect(response).to redirect_to(facts_path)
      end
    end

    context 'with invalid parameters' do
      it 're-renders the new page' do
        post :create, fact: {title: '', subject: ''}
        expect(response).to render_template('new')
      end
    end

  end
end