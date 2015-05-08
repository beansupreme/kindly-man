require 'rails_helper'

describe "Facts API" do
  let!(:leukemia_fact) { Fact.create!(title: 'Leukemia Treatment', subject: 'Is now being treated with a modified HIV strain') }
  let!(:cancer_fact) { Fact.create!(title: 'Cancer Treatment', subject: 'Is focusing on using modified viruses to attack tumors') }

  describe "GET /facts" do
    it 'returns 200' do
      get '/facts', {}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
    end

    it 'returns all the facts as json' do

      get '/facts', {}, {'Accept' => 'application/json'}

      body = JSON.parse(response.body)

      expect(body).to eq([
                             {
                                 'id' => leukemia_fact.id,
                                 'title' => 'Leukemia Treatment',
                                 'subject' =>'Is now being treated with a modified HIV strain'
                             },
                             {
                                 'id' => cancer_fact.id,
                                 'title' => 'Cancer Treatment',
                                 'subject' => 'Is focusing on using modified viruses to attack tumors'
                             }
                         ])

    end

    describe 'with search parameters' do
      let!(:tendonitis_fact) { Fact.create!(title: 'Tendonitis', subject: 'Often occurs in patellar tendon group')}
      let!(:knee_fact) { Fact.create!(title: 'Knee', subject: 'Is a joint' )}
      let!(:knight_fact) { Fact.create!(title: 'Knights', subject: 'protected their castle')}

      context 'when the search fields results' do
        let(:keywords) { 'kn' }
        it 'returns 200' do
          xhr :get, '/facts', format: :json, keywords: keywords

          expect(response.status).to eq(200)
        end

        it 'should return results which match' do
          xhr :get, '/facts', format: :json, keywords: keywords
          results = JSON.parse(response.body)

          expect(results.map{|r| r['title']}).to match_array(['Knee', 'Knights'])
        end
      end

      context 'when the search fields no results' do
        let(:keywords) { 'zilch' }
        it 'returns 200' do
          xhr :get, '/facts', format: :json, keywords: keywords

          expect(response.status).to eq(200)
        end

        it 'should return no results' do
          xhr :get, '/facts', format: :json, keywords: keywords
          results = JSON.parse(response.body)

          expect(results.map{|r| r['title']}).to be_empty
        end
      end
    end

  end

  describe 'GET /facts/:id' do
    context 'when the fact exists' do
      before do
        xhr :get, "/facts/#{leukemia_fact.id}", format: :json
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns the fact' do
        results = JSON.parse(response.body)
        expect(results).to eq({
                                  'id' => leukemia_fact.id,
                                  'title' => 'Leukemia Treatment',
                                  'subject' => 'Is now being treated with a modified HIV strain'
                              })
      end
    end

    context 'when the fact does not exist' do
      it 'returns 404' do
        xhr :get, "/facts/#{42}", format: :json
        expect(response.status).to be(404)
      end
    end
  end

  describe 'POST /facts' do
    it 'creates a new fact' do
      fact_params = {title: 'Radiohead', subject: 'Is the greatest band in the world'}
      post '/facts', {fact: fact_params}, {'Accept' => 'application/json'}

      expect(Fact.find_by_title('Radiohead')).to be_present
    end

    it 'returns the JSON body of the new fact' do
      fact_params = {title: 'Radiohead', subject: 'Is the greatest band in the world'}
      post '/facts', {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
      body = JSON.parse(response.body)

      expect(body).to eq(
                          'id' => Fact.last.id,
                          'title' => 'Radiohead',
                          'subject' => 'Is the greatest band in the world'
                      )

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
    let(:fact_params) {  {subject: 'Is being researched at University of Penn'} }
    it 'updates an existing fact' do
      put "/facts/#{leukemia_fact.id}", {fact: fact_params}, {'Accept' => 'application/json'}

      expect(Fact.where(subject: 'Is being researched at University of Penn').count).to be(1)
    end

    it 'returns the json body of the fact' do
      put "/facts/#{leukemia_fact.id}", {fact: fact_params}, {'Accept' => 'application/json'}

      expect(response.status).to be(200)
      body = JSON.parse(response.body)

      expect(body).to eq({
                             'id' => leukemia_fact.id,
                             'title' => 'Leukemia Treatment',
                             'subject' => 'Is being researched at University of Penn'
                         })
    end

    it 'returns a 400 with a bad request' do
      invalid_params = {subject: ''}
      put "/facts/#{leukemia_fact.id}", {fact: invalid_params}, {'Accept' => 'application/json'}

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