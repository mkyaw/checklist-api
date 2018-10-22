require 'rails_helper'

RSpec.describe 'Checklists API', type: :request do
  # initialize test data
  let!(:checklists) { create_list(:checklist, 10) }
  let(:checklist_id) { checklists.first.id }

  # Test suite for GET /checklists
  describe 'GET /checklists' do
    # make HTTP GET request before each test case
    before { get '/checklists' }

    it 'returns checklists' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /checklists/:id
  describe 'GET /checklists/:id' do
    # make HTTP POST request before each test case
    before { get "/checklists/#{checklist_id}" }

    context 'when the record exists' do
      it 'returns the checklist' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(checklist_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:checklist_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Checklist/)
      end
    end
  end

  # Test suite for POST /checklists
  describe 'POST /checklists' do
    # valid POST payload
    let(:valid_attributes) { { title: 'Learn Redux', created_by: '1' } }

    context 'when the request is valid' do
      # make HTTP POST reqeust before each test case
      before { post '/checklists', params: valid_attributes }

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Redux')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/checklists', params: { title: 'Bad bad title' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /checklists/:id
  describe 'PUT /checklists/:id' do
    # valid PUT payload
    let(:valid_attributes) { { title: 'Learn React First' } }

    context 'when the record exists' do
      # make HTTP PUT request before each test case
      before { put "/checklists/#{checklist_id}" }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /checklists/:id
  describe 'DELETE /checklists/:id' do
    before { delete "/checklists/#{checklist_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end