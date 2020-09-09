FactoryBot.define do
  factory :authenticate_token do
    body { Faker::Internet.uuid }
    last_used_at { Time.now.utc }
    expires_in { (Time.now.utc + 30.days).to_i }
    user_agent { Faker::Internet.user_agent }
    authenticateable_id { nil }
    authenticateable_type { nil }

    before :create do |auth|
      auth.authenticateable_id = auth.authenticator.id
      auth.authenticateable_type = auth.authenticator.class.name
    end
  end
end
