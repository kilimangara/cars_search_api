# frozen_string_literal: true

module ScoringApi
  class Client
    BASE_URL = 'https://bravado-images-production.s3.amazonaws.com'
    include Methods::Recommendations

    def get(path, params = {})
      result_url = prepare_url path, params
      Rails.logger.info("[ScoringApi]: sending get request: To: #{path}")
      request_options = build_request_options(
        method: :get,
        url: result_url
      )
      RestClient::Request.execute(request_options)
    rescue Errno::ECONNREFUSED, RestClient::Exception => e
      raise wrap_exception(e)
    end

    private

    def build_request_options(method:, url:, payload: nil, timeout: 3)
      {
        method: method,
        url: url,
        payload: payload,
        headers: {},
        timeout: timeout
      }.compact
    end

    def prepare_url(url, params = {})
      "#{BASE_URL}/#{url}?#{params.to_query}"
    end

    def wrap_exception(exc)
      clz = exception_class(exc)
      clz.new(message: nil, original_exception: exc)
    end

    def exception_class(exc)
      case exc
      when Errno::ECONNREFUSED
        ScoringApi::Exceptions::ConnectionFailed
      when RestClient::Exceptions::Timeout
        ScoringApi::Exceptions::Timeout
      else
        ScoringApi::Exceptions::Base
      end
    end
  end
end
