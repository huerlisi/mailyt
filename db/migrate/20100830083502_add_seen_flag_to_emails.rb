class AddSeenFlagToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :seen, :boolean
  end

  def self.down
    remove_column :emails, :seen
  end
end
