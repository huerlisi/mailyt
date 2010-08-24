class AddInReplyToIdToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :in_reply_to_id, :integer
  end

  def self.down
    remove_column :emails, :in_reply_to_id
  end
end
