class AddForeginKeyIntoUsers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :users, :user_types, column: :role

  end
end
