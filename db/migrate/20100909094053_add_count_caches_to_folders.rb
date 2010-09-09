class AddCountCachesToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :email_count, :integer
    add_column :folders, :unseen_count, :integer
  end

  def self.down
    remove_column :folders, :unseen_count
    remove_column :folders, :email_count
  end
end
