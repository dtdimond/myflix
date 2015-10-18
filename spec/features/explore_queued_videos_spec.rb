require 'spec_helper'

feature "User interacts with the queue" do
  background do

  end
  given!(:video1) { Fabricate(:video) }
  given!(:video2) { Fabricate(:video) }
  given!(:video3) { Fabricate(:video) }
  given(:user) { Fabricate(:user) }

  scenario "User adds video to queue and reorders them" do
    sign_in

    click_video video1
    expect(page).to have_content video1.title
    add_video_to_queue
    expect(page).to have_content video1.title

    #part 2
    click_video video1
    expect(page).not_to have_content "+ My Queue"

    #part 3
    visit root_path
    click_video video2
    add_video_to_queue

    visit root_path
    click_video video3
    add_video_to_queue #redirects to queued_videos_path

    change_video_orders([video1, video2, video3], [2,3,1])
    expect(queued_video_order(video1)).to eq("2")
    expect(queued_video_order(video2)).to eq("3")
    expect(queued_video_order(video3)).to eq("1")
  end
end

def click_video(video)
  find("a##{video.id}").click
end

def add_video_to_queue
  click_link '+ My Queue'
end

def change_video_orders(videos, orders)
  videos.zip(orders).each do |video, order|
    fill_in "queued_video_order_#{video.id}", with: order
  end

  click_button "Update Instant Queue"
end

def queued_video_order(video)
  find("#queued_video_order_#{video.id}").value
end
