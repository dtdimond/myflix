Fabricator(:video) do
  title { Faker::Lorem.words(4).join(" ") }
  description { Faker::Lorem.words(13).join(" ") }
  category
  reviews(count:  2)
end