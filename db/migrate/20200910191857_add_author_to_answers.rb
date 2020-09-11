class AddAuthorToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :author, :string, null: false
  end
end
