# frozen_string_literal: true

class BarDomain
  def self.matches?(request)
    request.host == 'bar-domain.local'
  end
end
