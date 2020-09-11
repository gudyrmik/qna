class AddAuthorToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :author, :string, null: false
  end
end
