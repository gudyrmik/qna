class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :value
      t.references :user, foreign_key: true
      t.belongs_to :likeable, polymorphic: true
      t.timestamps
    end
  end
end
