ActionMailer::Base.delivery_method = :sendmail unless Rails.env.test?
