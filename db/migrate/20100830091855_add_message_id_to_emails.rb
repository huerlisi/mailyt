class AddMessageIdToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :message_id, :string
  end

  def self.down
    remove_column :emails, :message_id
  end
end
