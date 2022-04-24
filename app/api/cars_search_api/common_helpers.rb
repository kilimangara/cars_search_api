# frozen_string_literal: true

module CarsSearchAPI
  module CommonHelpers
    extend Grape::API::Helpers

    DEFAULT_LIMIT = 500

    DEFAULT_PER_PAGE = 20

    TOTAL_HEADER = 'X-Total-Pages'

    params :pagination do
      optional :page, type: Integer, default: 1, desc: 'Номер страницы'
      optional :per_page, type: Integer, default: DEFAULT_PER_PAGE, desc: 'Количество элементов на странице'
    end

    def permitted_params
      declared(params, include_missing: false)
    end

    def pagination_params
      {
        page: params[:page],
        per_page: params[:per_page]
      }
    end

    def write_pagination_info(paginated_query)
      header TOTAL_HEADER, String(paginated_query.total_pages)
      header 'Access-Control-Expose-Headers', "#{TOTAL_HEADER}"
    end

    def get_paginated_response(query)
      params = pagination_params.merge(total_entries: query.count)
      paginated_query = query.paginate(params)
      write_pagination_info(paginated_query)
      paginated_query
    end
  end
end
