# Contains shared methods for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    render file: Rails.root.join('public', '404'), layout: false,
           status: :not_found
  end
end
