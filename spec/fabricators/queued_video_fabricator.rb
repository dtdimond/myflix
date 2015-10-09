Fabricator(:queued_video) do
  order { sequence(:order, 1) }
  video
  user
end