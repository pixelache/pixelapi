# frozen_string_literal: true

# disable coverage for now to speed these tests up

require 'simplecov'
require "active_record"
# require "bullet"
SimpleCov.start 'rails'
RSpec.configure do |config|
  config.fail_fast = 1
  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end 
  end
end

# let's do these tests in English, eh?
I18n.locale = :en

