require 'spec_helper'

feature "User interacts with another users profile" do
  given(:other_user) { Fabricate(:user) }
  given(:other_user2) { Fabricate(:user) }
  given!(:video1) { Fabricate(:video, reviews: [Fabricate(:review, user: other_user),
                                                Fabricate(:review, user: other_user2)]) }
  given!(:queued_video) { Fabricate(:queued_video, user: other_user, video: video1) }

  scenario "by visiting another users profile" do
    sign_in

    #Go to user profile
    click_video video1
    expect(page).to have_content other_user.full_name

    #Ensure queued vids and reviews are there for that user
    click_user other_user
    expect(page).to have_content "#{other_user.full_name}'s video collections
                                  (#{other_user.queued_videos.count})"
    expect(page).to have_content other_user.reviews.first.text

    #Navigate back to a video page. Ensure works
    click_video video1
    expect(page).to have_content video1.title
  end

  scenario "through exploring the follow feature" do
    sign_in

    #Find a user via their review on video and follow them
    click_video video1
    click_user other_user
    expect(page.find_button("Follow")).not_to be_nil
    expect(page).to have_xpath("//input[@value='Follow']")
    follow_user
    expect(page).to have_content("People I Follow")
    expect(page).to have_content other_user.full_name

    #Find and follow another user
    visit root_path
    click_video video1
    click_user other_user2
    follow_user
    expect(page).to have_content other_user2.full_name

    #Unfollow the first user
    unfollow_user other_user
    expect(page).not_to have_content other_user.full_name

    #Ensure we can still navigate to second user's profile from here
    click_user other_user2
    expect(page).not_to have_xpath("//input[@value='Follow']")
    expect(page).to have_content other_user2.full_name
  end
end

def click_user(user)
  click_link "#{user.full_name}"
end

def click_video(video)
  find("a##{video.id}").click
end

def follow_user
  click_button 'Follow'
end

def unfollow_user(user)
  following = Following.find_by(follow_id: user.id)
  find("a##{following.id}").click
end
