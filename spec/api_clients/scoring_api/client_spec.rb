# frozen_string_literal: true

RSpec.describe ScoringAPI::Client do
  describe '#get' do
    subject { described_class.new.get('some_api.json') }

    context 'success response' do
      before do
        WebMock
          .stub_request(:get, "#{ScoringAPI::Client::BASE_URL}/some_api.json")
          .and_return(status: 200, body: '{}')
      end

      it 'returns Response object' do
        expect(subject).to be_an RestClient::Response
      end
    end

    context 'when request timeouts' do
      before do
        WebMock
          .stub_request(:get, "#{ScoringAPI::Client::BASE_URL}/some_api.json")
          .to_raise(RestClient::Exceptions::Timeout)
      end

      it 'returns Response object' do
        expect{ subject }.to raise_error ScoringAPI::Exceptions::Timeout
      end
    end

    context 'when request connection fails' do
      before do
        WebMock
          .stub_request(:get, "#{ScoringAPI::Client::BASE_URL}/some_api.json")
          .to_raise(SocketError)
      end

      it 'returns Response object' do
        expect { subject }.to raise_error ScoringAPI::Exceptions::ConnectionFailed
      end
    end

    context 'when request fails another way' do
      before do
        WebMock
          .stub_request(:get, "#{ScoringAPI::Client::BASE_URL}/some_api.json")
          .to_raise(RestClient::ResourceNotFound)
      end

      it 'returns Response object' do
        expect { subject }.to raise_error ScoringAPI::Exceptions::Base
      end
    end
  end

  describe '#recommended_cars' do
    let(:user_id) { 1 }
    subject { described_class.new.recommended_cars(user_id) }

    context do
      before do
        content = File.read(
          Rails.root.join('spec', 'api_clients', 'scoring_api', 'responses', 'success.json')
        )
        WebMock
          .stub_request(:get, "#{ScoringAPI::Client::BASE_URL}/recomended_cars.json?user_id=#{user_id}")
          .and_return(status: 200, body: content)
      end

      it 'returns list of ScoringAPI::Struct::Recommendation' do
        expect(subject.struct).to all(be_an(ScoringAPI::Struct::Recommendation))
      end
    end
  end
end
