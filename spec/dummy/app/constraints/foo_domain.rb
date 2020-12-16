# frozen_string_literal: true

class FooDomain
  def self.matches?(request)
    request.host == 'foo-domain.local'
  end
end
