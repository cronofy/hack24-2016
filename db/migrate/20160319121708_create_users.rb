class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :slack_user_id
      t.string :slack_access_token
      t.string :slack_team_id

      t.timestamps null: false
    end
  end
end
