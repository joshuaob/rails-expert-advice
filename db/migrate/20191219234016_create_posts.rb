class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :description, null: false
      t.integer :question_id, null: false, index: true
      t.timestamps
    end
  end
end
