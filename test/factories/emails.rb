# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :email do |f|
  f.from "MyString"
  f.to "MyString"
  f.subject "MyString"
  f.date "MyString"
  f.body "MyText"
end
