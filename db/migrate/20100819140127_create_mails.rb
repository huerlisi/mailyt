class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :date
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end
