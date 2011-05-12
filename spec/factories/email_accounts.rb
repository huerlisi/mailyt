# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :email_account do |f|
  f.server "MyString"
  f.username "MyString"
  f.password "MyString"
end
