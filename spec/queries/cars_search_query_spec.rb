# frozen_string_literal: true

RSpec.describe UserCarsQuery do
  fixtures :cars, :brands

  let(:preferred_brands) { [Brand.find(1)] }
  let(:preferred_price_range) { 15_000...35_000 }
  let(:user) { create(:user, preferred_brands: preferred_brands, preferred_price_range: preferred_price_range) }
  let(:params) { {page: 1, per_page: 20} }
  subject(:query) { described_class.new(user, params).apply }

  describe '#apply' do
    context 'with query param' do
      it 'full search works fine' do
        params[:query] = 'BMW'
        expect(query).to include(Car.find(2))
      end

      it 'ilike search' do
        params[:query] = 'acu'
        expect(query).to include(Car.find(1))
      end
    end

    context 'with max and min price' do
      it 'min price works fine' do
        params[:min_price] = 25_000
        expect(query).not_to include(Car.find(1))
      end

      it 'max price works fine' do
        params[:max_price] = 35_000
        expect(query).not_to include(Car.find(3))
      end

      it 'both works fine' do
        params[:min_price] = 105_000
        params[:max_price] = 106_000
        expect(query).to eq([Car.find(7)])
      end
    end

    context 'when scorings available' do
      before do
        UserCarsScoring.create!(user_id: user.id, car_id: 1, scoring: 0.7)
        UserCarsScoring.create!(user_id: user.id, car_id: 2, scoring: 0.55)
      end

      it 'perfect matched correctly' do

        matched = query.to_a.select { |el| el.label_score == UserCarsQuery::PERFECT_MATCH }
        expect(matched).to include(Car.find(1))
      end

      it 'good matched correctly' do
        matched = query.to_a.select { |el| el.label_score == UserCarsQuery::GOOD_MATCH }
        expect(matched).to include(Car.find(3))
      end

      it 'has correct ordering' do
        right_ordering = [1, 3, 4, 2, 5, 8, 6, 7]

        expect(query.to_a.map(&:id)).to eq(right_ordering)
      end
    end
  end
end
