class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user, index: true, foreign_key: {to_table: :users}
      t.references :friend, index: true, foreign_key: {to_table: :users}
      t.boolean :accepted, null: false
      
      t.timestamps
    end
  end
end
