require 'rails_helper'

RSpec.describe "Api::V1::Stats", type: :request do
  let(:headers) { {"ACCEPT" => "application/json"} }
  let(:body)    { JSON.parse(response.body, symbolize_names: true) }
  let(:params)  { {stat: attributes } }

  describe "PATCH /update" do
    let(:stat) { create :stat, :valid }
    let(:attributes) { { value: 4 } }

    it 'updates the stat value' do
      expect(stat.value).to eq(3.5)

      patch "/api/v1/goals/#{stat.goal.id}/stats/#{stat.id}", params: params, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)

      expect(stat.reload.value).to eq(4)
    end

    context 'if the stat is in the future' do
      let(:stat) { create :stat, :in_future }
      let(:attributes) { { value: 5 } }

      it 'returns a 422' do
        expect(stat.value).to be(nil)

        patch "/api/v1/goals/#{stat.goal.id}/stats/#{stat.id}", params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body[:errors][:value]).to contain_exactly("cannot be set before occurence")

        expect(stat.reload.value).to be(nil)
      end
    end

    context 'with invalid goal_id' do
      let(:unrelated_goal) { create :goal, :valid }

      it 'returns a 404' do
        expect(stat.value).to eq(3.5)
  
        patch "/api/v1/goals/#{unrelated_goal.id}/stats/#{stat.id}", params: params, headers: headers
  
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:not_found)
  
        expect(stat.reload.value).to eq(3.5)
      end
    end
  end
end
