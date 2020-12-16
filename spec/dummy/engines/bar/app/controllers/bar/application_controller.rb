# frozen_string_literal: true

module Bar
  class ApplicationController < ActionController::Base
    layout 'bar/application'
    localized :bar_engine
    around_action :set_locale_from_params
  end
end
