RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# FactoryGirl.definition_file_paths << File.expand_path('./factories.rb', __FILE__)
# FactoryGirl.find_definitions
