require 'rails_helper'

describe FactsController do
  let!(:leukemia_fact) { Fact.create!(title: 'Leukemia Treatment', subject: 'Is now being treated with a modified HIV strain') }
  let!(:cancer_fact) { Fact.create!(title: 'Cancer Treatment', subject: 'Is focusing on using modified viruses to attack tumors') }

  describe 'GET #index' do
    it 'returns 200' do
      xhr :get, :index, format: :json
      expect(response.code).to eq('200')
    end

    it 'returns all of the facts' do
      xhr :get, :index, format: :json
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
  end

  describe 'GET #show' do
    context 'when the fact exists' do
      before do
        xhr :get, :show, id: leukemia_fact.id, format: :json
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
        xhr :get, :show, id: 42, format: :json
        expect(response.status).to be(404)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'can create a new fact' do
        fact_params = {title: 'Kombucha', subject: 'Has scoby'}
        xhr :post, :create, format: :json, fact: fact_params

        expect(Fact.find_by_title('Kombucha')).to be_present
      end

      it 'returns the JSON body of the new fact' do
        fact_params = {title: 'Radiohead', subject: 'Is the greatest band in the world'}
        xhr :post, :create, format: :json, fact: fact_params

        expect(response.status).to be(200)
        body = JSON.parse(response.body)

        expect(body).to eq(
                            'id' => Fact.last.id,
                            'title' => 'Radiohead',
                            'subject' => 'Is the greatest band in the world'
                        )

      end

    end

    context 'with invalid parameters' do
      it 'returns 400 and errors' do
        xhr :post, :create, format: :json, fact: {title: 'Blank subject', subject: ''}
        expect(response.status).to be(400)

        body = JSON.parse(response.body)

        expect(body['errors']).to eq({
                                         'subject' => ["can't be blank"]
                                     })
      end
    end
  end

  describe 'PUT #update' do
    it 'can update an existing fact' do
      xhr :put, :update, id: cancer_fact.id, format: :json, fact: {title: 'Tomato Sauce', subject: 'contains tomatoes'}
      updated_fact = Fact.find cancer_fact.id
      expect(updated_fact.title).to eq('Tomato Sauce')
      expect(updated_fact.subject).to eq('contains tomatoes')
    end

    it 'returns the json body of the fact' do
      xhr :put, :update, id: leukemia_fact.id, format: :json, fact: {subject: 'Is being researched at University of Penn'}

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
      xhr :put, :update, id: leukemia_fact.id, format: :json, fact: invalid_params

      expect(response.status).to be(400)
      body = JSON.parse(response.body)

      expect(body['errors']).to eq({
                                       'subject' => ["can't be blank"]
                                   })
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys an existing fact' do
      xhr :delete, :destroy, id: leukemia_fact.id, format: :json

      expect(response.status).to be(200)
      expect(Fact.find_by_id(leukemia_fact.id)).to be_nil
    end
  end
end