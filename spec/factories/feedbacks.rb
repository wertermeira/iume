FactoryBot.define do
  factory :feedback do
    owner { create(:owner) }
    screen { 'screen' }
    body { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true) }
  end
end
