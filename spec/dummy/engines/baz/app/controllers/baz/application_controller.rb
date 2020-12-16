# frozen_string_literal: true

module Baz
  class ApplicationController < ActionController::Base
    layout 'baz/application'
    localized :baz_engine
    around_action :set_locale_from_params
  end
end
