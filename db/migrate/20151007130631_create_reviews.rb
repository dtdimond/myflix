class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :text
      t.decimal :rating
      t.integer :user_id
      t.integer :video_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
