# frozen_string_literal: true

describe CarsSearchAPI::V1::Search do
  describe 'GET /cars' do
    before do
      allow_any_instance_of(CacheUserRecommendationsService).to receive(:cache_in_runtime).and_return(nil)
      create(:user)
    end

    let(:user) { create(:user) }

    it 'returns channels list' do
      get '/api/search/v1/cars', params: { user_id: user.id }

      expect(response.status).to eq(200)
    end

    it 'returns errors if no user existed' do
      get '/api/search/v1/cars', params: { user_id: user.id + 1 }

      expect(response.status).to eq(404)
    end

    it 'returns errors if no user_id param' do
      get '/api/search/v1/cars'

      expect(response.status).to eq(422)
    end
  end
end
