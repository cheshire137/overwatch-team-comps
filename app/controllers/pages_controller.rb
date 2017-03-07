class PagesController < ApplicationController
  def show
    case params[:page]
    when "styleguide"
      render template: 'pages/styleguide'
    else
      render_404
    end
  end
end
