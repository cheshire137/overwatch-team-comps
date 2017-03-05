require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OverwatchTeamComps
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # https://github.com/browserify-rails/browserify-rails#using-browserify-transforms
    config.browserify_rails.commandline_options = "-t [ babelify --presets [ es2015 react ] --extensions .es6 ]"
  end
end
