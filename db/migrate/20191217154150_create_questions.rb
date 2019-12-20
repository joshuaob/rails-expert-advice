class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :slug, null: false, index: true, unique: true
      t.string :title, null: false, index: true
      t.string :tags, index: true
      t.text :description, null: false
      t.integer :user_id, null: false, index: true
      t.timestamps
    end
  end
end
