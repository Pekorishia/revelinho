class InterviewDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def formatting_datetime
    I18n.l(interview.date, format: :long) + ', das ' + interview.time_from +
      ' às ' + interview.time_to
  end

  def interview_address
    I18n.t('activerecord.attributes.interview.address',
           address: interview.address)
  end

  def interview_format
    I18n.t('activerecord.attributes.interview.format.' + interview.format)
  end

  def decision_buttons
    return '' unless interview.pending?

    reject_button + accept_button
  end

  def interview_status_badge
    return badge('scheduled') if interview.scheduled?
    return badge('canceled') if interview.canceled?

    badge('pending')
  end

  private

  def badge(status)
    content_tag(:span, I18n.t('interview.status_badge.' + status),
                class: 'mb-2 badge badge-' + status)
  end

  def accept_button
    link_to 'Aceitar', accept_interview_candidate_path(interview),
            class: 'btn btn-outline-success', method: :post
  end

  def reject_button
    link_to 'Recusar', reject_interview_candidate_path(interview),
            class: 'btn btn-outline-danger', method: :post
  end
end
