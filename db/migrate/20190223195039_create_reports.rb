class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.timestamp :start
      t.timestamp :finish
      t.integer :user_id

    end
    add_foreign_key :reports, :users
  end
end
