FactoryBot.define do
  factory :item do
    name { Faker::StarWars.character }
    done { false }
    checklist_id { nil }
  end
end