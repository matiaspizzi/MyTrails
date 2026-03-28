module AuthenticationHelpers
  def sign_in(user)
    session = user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1")
    cookies.signed[:session_id] = session.id
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
