class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
