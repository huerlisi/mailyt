class CreateEmailAccounts < ActiveRecord::Migration
  def self.up
    create_table :email_accounts do |t|
      t.string :server
      t.string :username
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :email_accounts
  end
end
