require 'rails_helper'

describe "Facts API" do
  let!(:leukemia_fact) { Fact.create!(title: 'Leukemia Treatment', subject: 'Is now being treated with a modified HIV strain') }
  let!(:cancer_fact) { Fact.create!(title: 'Cancer Treatment', subject: 'Is focusing on using modified viruses to attack tumors') }

  describe "GET /facts" do
    it 'returns 200' do
      get '/facts', {}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
    end

    it 'returns all the fact titles' do

      get '/facts', {}, {'Accept' => 'application/json'}

      body = JSON.parse(response.body)

      fact_titles = body.map { |fact| fact['title'] }
      expect(fact_titles).to match_array(['Leukemia Treatment', 'Cancer Treatment'])
    end

    it 'returns all the fact subjects' do
      get '/facts', {}, {'Accept' => 'application/json'}

      body = JSON.parse(response.body)

      fact_subjects = body.map { |fact| fact['subject'] }
      expect(fact_subjects).to match_array([
                                             'Is now being treated with a modified HIV strain',
                                             'Is focusing on using modified viruses to attack tumors'
                                         ])
    end
  end

  describe 'POST /facts' do
    it 'creates a new fact' do
      fact_params = {title: 'Radiohead', subject: 'Is the greatest band in the world'}
      post '/facts', {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
      body = JSON.parse(response.body)

      expect(body['title']).to eq('Radiohead')
      expect(body['subject']).to eq('Is the greatest band in the world')
    end

    it 'returns 400 with a bad request' do
      fact_params = {title: 'Blank subject', subject: ''}
      post '/facts', {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(400)
      body = JSON.parse(response.body)

      expect(body['errors']).to eq({
                                       'subject' => ["can't be blank"]
                                   })
    end
  end

  describe 'PUT /facts/:id' do
    it 'updates an existing fact' do
      fact_params = {subject: 'Is being researched at University of Penn'}
      put "/facts/#{leukemia_fact.id}", {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
      body = JSON.parse(response.body)

      expect(body['subject']).to eq('Is being researched at University of Penn')
    end

    it 'returns a 400 with a bad request' do
      fact_params = {subject: ''}
      put "/facts/#{leukemia_fact.id}", {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(400)
      body = JSON.parse(response.body)

      expect(body['errors']).to eq({
                                       'subject' => ["can't be blank"]
                                   })
    end
  end

  describe 'DELETE /facts/:id' do
    it 'destroys an existing fact' do
      delete "/facts/#{leukemia_fact.id}", {}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
      expect(Fact.find_by_id(leukemia_fact.id)).to be_nil
    end
  end
end