class AddThreadIdToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :thread_id, :string
  end

  def self.down
    remove_column :emails, :thread_id
  end
end
