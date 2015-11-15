Fabricator(:following) do
  user
  follow { Fabricate(:user) }
end