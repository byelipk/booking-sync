require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/spec'

class ActiveSupport::TestCase
  extend MiniTest::Spec::DSL

  # Add more helper methods to be used by all tests here...
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def authenticate!
    { "X-HAPPY-DAYS" => "make-me-feel-fine" }
  end
end
