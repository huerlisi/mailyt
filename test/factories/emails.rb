Factory.define :simple_email, :class => Email do |f|
  f.from "from@example.com"
  f.to "to@example.org"
  f.subject "Simple mail"
  f.date DateTime.parse("2001-01-01 08:15")
  f.body "Some text"
end

Factory.define :thread_head, :parent => :simple_email do |f|
  f.subject "Original mail"
end

Factory.define :thread_child, :parent => :simple_email do |f|
  f.subject "Re: Original mail"
  f.date DateTime.parse("2001-01-02")
  f.from "to@example.org"
  f.to "from@example.com"
  f.in_reply_to Factory(:thread_head)
end
