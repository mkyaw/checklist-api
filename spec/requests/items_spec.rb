require 'rails_helper'

RSpec.describe('Items API') do
  # Initialize the test data
  let!(:checklist) { create(:checklist) }
  let!(:items) { create_list(:item, 20, checklist_id: checklist.id) }
  let(:checklist_id) { checklist.id }
  let(:id) { items.first.id }

  # Test suite for GET /checklists/:checklist_id/items
  describe 'GET /checklists/:checklist_id/items' do
    before { get "/checklists/#{checklist_id}/items" }

    context 'when checklist exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all checklist items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when checklist does not exist' do
      let(:checklist_id) { 0 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Checklist/)
      end
    end
  end

  # Test suite for GET /checklists/:checklist_id/items/:id
  describe 'GET /checklists/:checklist_id/items/:id' do
    before { get "/checklists/#{checklist_id}/items/#{id}" }

    context 'when checklist item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when checklist item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for POST /checklists/:checklist_id/items
  describe 'POST /checklists/:checklist_id/items' do
    let(:valid_attributes) { { name: 'Create Component', done: false } }

    context 'when request attributes are valid' do
      before { post "/checklists/#{checklist_id}/items", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/checklists/#{checklist_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /checklists/:checklist_id/items/:id

  describe 'PUT /checklists/:checklist_id/items/:id' do
    let(:valid_attributes) { { name: 'Create Stateless Component' } }

    before { put "/checklists/#{checklist_id}/items/#{id}" }

    context 'when the item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(id)
        expect(response.body).to be_empty
      end
    end

    context 'when the item does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for DELETE /checklists/:checklist_id/items/:id
  describe 'DELETE /checklists/:checklist_id/items/:id' do
    before { delete "/checklists/#{checklist_id}/items/#{id}" }

    context 'when the item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the item does not exist' do
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end