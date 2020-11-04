class AddBestToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, unique: true, default: false
  end
end
