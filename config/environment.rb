# Load the rails application
require File.expand_path('../application', __FILE__)

FlickRawOptions = {
  "api_key" => "102b5abb3630dfebf56162816ce764c9",
  "shared_secret" => "de4a6e8f592ce5a1",
  "auth_token" => "72157624183057188-2a2cfd75aee7b532",
}
# Initialize the rails application
Nomads::Application.initialize!
