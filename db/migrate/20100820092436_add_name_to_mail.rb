class AddNameToMail < ActiveRecord::Migration
  def self.up
    add_column :mails, :name, :string
  end

  def self.down
    remove_column :mails, :name
  end
end
