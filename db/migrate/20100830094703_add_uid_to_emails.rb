class AddUidToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :uid, :integer
  end

  def self.down
    remove_column :emails, :uid
  end
end
