# frozen_string_literal: true

class MainDomain
  def self.matches?(request)
    request.host == 'main-domain.local'
  end
end
