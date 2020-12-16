# frozen_string_literal: true

module Foo
  class ApplicationController < ActionController::Base
    layout 'foo/application'
    localized :foo_engine
    around_action :set_locale_from_params
  end
end
