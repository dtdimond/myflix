# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(title: "Historical")
Category.create(title: "Pyschothriller")

user1 = User.create(full_name: "John Moviegoer", email: "john@movies.com", password: "Password")
user2 = User.create(full_name: "John Cineman", email: "cineman@movies.com", password: "Password")

braveheart = Video.create(title: "Braveheart",
                          description: "Mel Gibson gets angry.",
                          small_cover_url: "/tmp/monk.jpg",
                          large_cover_url: "/tmp/monk_large.jpg",
                          category_id: 1)

machina = Video.create(title: "Ex Machina",
                       description: "Robots be crazy.",
                       small_cover_url: "/tmp/family_guy.jpg",
                       large_cover_url: "/tmp/futurama.jpg",
                       category_id: 2)

Review.create(text: "Braveheart sucks.", rating: 1, video: braveheart, user: user1)
Review.create(text: "Best movie ever.", rating: 4, video: braveheart, user: user1)

QueuedVideo.create(order: 1, video: Video.first, user: user1)
QueuedVideo.create(order: 2, video: Video.second, user: user1)
QueuedVideo.create(order: 1, video: Video.second, user: user2)
