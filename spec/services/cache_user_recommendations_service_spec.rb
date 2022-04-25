RSpec.describe CacheUserRecommendationsService do
  fixtures :cars, :brands

  let(:user) { create(:user, preferred_brands: Brand.limit(5)) }
  subject(:service) { described_class.new(user) }

  describe '#call' do
    before do
      stubbed_scoring = OpenStruct.new(
        struct:[
          ScoringAPI::Struct::Recommendation.new(car_id: 1, rank_score: 0.1),
          ScoringAPI::Struct::Recommendation.new(car_id: 2, rank_score: 0.95),
          ScoringAPI::Struct::Recommendation.new(car_id: 3, rank_score: 0.05),
          ScoringAPI::Struct::Recommendation.new(car_id: 4, rank_score: 0.55),
          ScoringAPI::Struct::Recommendation.new(car_id: 5, rank_score: 0.76),
          ScoringAPI::Struct::Recommendation.new(car_id: 6, rank_score: 0.25),
          ScoringAPI::Struct::Recommendation.new(car_id: 7, rank_score: 0.11),
          ScoringAPI::Struct::Recommendation.new(car_id: 8, rank_score: 0.15)
        ]
      )
      allow_any_instance_of(ScoringAPI::Client).to receive(:recommended_cars).and_return(stubbed_scoring)
    end

    it 'caches at all' do
      expect { service.call }.to change { user.user_cars_scorings.count }.by(5)
    end

    it 'caches properly' do
      service.call

      expect(user.user_cars_scorings.pluck(:car_id)).to eq([2, 5, 4, 6, 8])
    end
  end
end
