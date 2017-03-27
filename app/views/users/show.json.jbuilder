json.user do
  json.auth true
  json.battletag @user.battletag
  json.authenticityToken form_authenticity_token
  json.platform @user.platform
  json.region @user.region
  json.email @user.email
end
