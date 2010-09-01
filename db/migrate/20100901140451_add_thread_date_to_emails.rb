class AddThreadDateToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :thread_date, :datetime
  end

  def self.down
    remove_column :emails, :thread_date
  end
end
