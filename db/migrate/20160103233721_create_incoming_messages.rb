class CreateIncomingMessages < ActiveRecord::Migration
  def change
    create_table :incoming_messages do |t|
      t.string :mailer
      t.string :title
      t.string :body
      t.datetime :data
      t.string :main_recipient
      t.string :other_recipients

      t.timestamps null: false
    end
  end
end
