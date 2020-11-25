class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :title, null: false
      t.references :question, foreign_key: true
      t.references :user

      t.timestamps
    end
  end
end
