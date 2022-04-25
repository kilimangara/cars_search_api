# frozen_string_literal: true

class NullMockObject
  def initialize(*args); end

  def method_missing(*args); end
end
