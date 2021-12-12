# frozen_string_literal: true

RAILS_VERSIONS = %w[
  5.2.6
  6.0.4
  6.1.4
  7.0.0.rc1
].freeze

RAILS_VERSIONS.each do |version|
  appraise "rails_#{version}" do
    gem 'rails', version
    gem 'sqlite3', '~> 1.3.0' unless ['6.0.4', '6.1.4', '7.0.0.rc1'].include?(version)
  end
end
