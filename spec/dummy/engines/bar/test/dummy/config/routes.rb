Rails.application.routes.draw do
  mount Bar::Engine => "/bar"
end
