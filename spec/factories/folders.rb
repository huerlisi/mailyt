# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :folder do |f|
  f.parent_id 1
  f.title "MyString"
  f.email_account_id 1
end
