Fabricator(:review) do
  text { Faker::Lorem.paragraph }
  rating { Faker::Number.between(from = 0, to = 5) }
end