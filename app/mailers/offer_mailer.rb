class OfferMailer < ApplicationMailer
  def notify_candidate(offer_id)
    @offer = Offer.find(offer_id)
    @position = @offer.position
    @company = @offer.position.company
    subject = 'Você recebeu uma proposta para a posição ' +
              @offer.position.title

    mail(to: @offer.candidate.email, subject: subject)
  end

  def notify_accepted(offer_id)
    @offer = Offer.find(offer_id)
    subject = "Proposta aceita para #{@offer.position.title}"

    mail(to: @offer.employee.email, subject: subject)
  end

  def notify_rejected(offer_id)
    @offer = Offer.find(offer_id)
    subject = "Proposta recusada para #{@offer.position.title}"

    mail(to: @offer.employee.email, subject: subject)
  end
end
