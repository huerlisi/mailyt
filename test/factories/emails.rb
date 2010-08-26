Factory.define :simple_email do |f|
  f.from "from@example.com"
  f.to "to@example.org"
  f.subject "Simple mail"
  f.date DateTime.parse("2001-01-01 08:15")
  f.body "Some text"
end

Factory.define :replied_email, :parent => :simple_email do |f|
  f.subject "Original mail"
  f.build_reply
end
