class RentRequestsMailer < ActionMailer::Base
  helper :rent_requests

  default from: "support@novarent.com.ua"

  def owner(rent_request)
    @rent_request = rent_request
    mail(to: 'info@novarent.com.ua', subject: I18n.t('mailers.rent_requests.owner.subject'))
  end

  def client(rent_request)
    @rent_request = rent_request
    mail(to: rent_request.email, subject: I18n.t('mailers.rent_requests.client.subject'))
  end
end
