require 'devise'

class OverwatchTeamCompsDeviseFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      json_failure
    else
      super
    end
  end

  def json_failure
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = '{"error": "You must be signed in."}'
  end
end
