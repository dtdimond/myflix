Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Internet.password(10) }
  full_name { Faker::Name.name }
end