class AddAttachmentToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :attachment, :string
  end
end
