class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :name
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
