# frozen_string_literal: true

if [Rails::VERSION::MAJOR, Rails::VERSION::MINOR] == [5, 2]
  Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
end
