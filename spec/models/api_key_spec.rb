require 'spec_helper'

describe ApiKey do
  let(:user) {create(:user)}
  let(:session_key) {create(:api_key, user_id: user.id)}
  let(:api_key) {create(:api_key, scope: "api", user_id: user.id)}

  it "generates access token" do
    session_key.access_token.should match(/\S{32}/)
  end

end
