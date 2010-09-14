class AddFolderPropertiesToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :subscribed, :boolean
    add_column :folders, :synced, :boolean
  end

  def self.down
    remove_column :folders, :synced
    remove_column :folders, :subscribed
  end
end
