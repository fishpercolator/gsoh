ActionMailer::Base.default_url_options = {
  host: ENV['DOMAIN_IN_EMAIL_LINKS'] || ENV['DOMAIN_NAME'],
  protocol: 'https'
}
ActionMailer::Base.default_options = {
  from: ENV['EMAIL_FROM']
}
