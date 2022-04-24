# frozen_string_literal: true

module CommonAPIUtils
  module Entity
    class Error < Grape::Entity
      expose :error, documentation: { type: 'string', desc: 'Error message', required: true }
    end
  end
end
