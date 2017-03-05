ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

FactoryGirl.definition_file_paths << File.expand_path('./factories.rb', __FILE__)
FactoryGirl.find_definitions
