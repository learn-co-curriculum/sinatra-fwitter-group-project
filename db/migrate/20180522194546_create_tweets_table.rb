class CreateTweetsTable < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :content
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
