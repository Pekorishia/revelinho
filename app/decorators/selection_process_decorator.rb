# rubocop:disable Metrics/ClassLength
class SelectionProcessDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def contract_resume
    p_print_hiring_scheme + p_print_office_hours + p_print_salary
  end

  def go_back_button(user)
    return invites_candidates_path if user.is_a? Candidate

    candidates_path
  end

  def messages_show
    messages.order(id: :desc).decorate
  end

  def offers_menu
    return msg_offer if employee_signed_in?
    return menu_candidate if offers.pending.any?
    return menu_accepted if offers.accepted.any?

    ''
  end

  def main_contact
    return main_content(employee_data) if candidate_signed_in?

    main_content(candidate_data)
  end

  def p_print_hiring_scheme
    content_tag(:p, 'Regime de contratação: ' +
      I18n.t('activerecord.enums.position.hiring_scheme.' +
      position.hiring_scheme), class: 'mb-0')
  end

  def p_print_office_hours
    content_tag(:p, 'Horário de expediente: ' +
      I18n.t('activerecord.enums.position.office_hours.' +
      position.office_hours), class: 'mb-0')
  end

  def p_print_salary
    content_tag(:p, "Salário: #{number_to_currency(position.salary_from)}"\
      " à #{number_to_currency(position.salary_to)}", class: 'mb-0')
  end

  def btn_schedule_interview
    if employee_signed_in?
      link_to 'Agendar nova entrevista',
              new_selection_process_interview_path(id),
              class: 'btn btn-outline-info btn-sm mb-3'
    else
      ''
    end
  end

  def image_logo
    logo = candidate.candidate_profile.avatar.attached?
    return candidate.candidate_profile.avatar if logo

    image_url('placeholder.png')
  end

  private

  def buttons
    btn('Aceitar proposta', 'accept_candidate_offer_path', 'success') +
      btn('Rejeitar proposta', 'reject_candidate_offer_path', 'danger')
  end

  def btn(text, path, style)
    link_to(text, send(path, candidate.id, id, offers.pending.first.id),
            class: "btn btn-#{style} btn-lg mt-2 mr-3", method: 'post')
  end

  def menu_accepted
    content_tag :div, class: 'card card-body bg-success text-white' do
      content_tag(:h4, 'Oferta aceita!') +
        content_tag(:p, 'Agora é só aguardar o contato de sua nova casa!') +
        content_tag(:p, 'Nós da Revelinho desejamos muito sucesso em '\
                        'sua carreira. :D')
    end
  end

  def menu_candidate
    content_tag :div, class: 'card card-body text-center' do
      content_tag(:h4, 'PROPOSTA RECEBIDA! \o/') +
        content_tag(:p, 'Parabéns! Você recebeu uma proposta. Agora avalie '\
                        'e veja se atende as suas expectativas') +
        content_tag(:p, offer_description(offers.pending.first)) +
        content_tag(:div, buttons, class: 'text-center')
    end
  end

  def offer_description(offer)
    content_tag(:p, "Salário: #{number_to_currency(offer.salary)}",
                class: 'mb-0') +
      content_tag(:p, "Regime de contratação: #{I18n.t('activerecord.attribute'\
                      "s.offer.hiring_scheme.#{offer.hiring_scheme}")}",
                  class: 'mb-0') +
      content_tag(:p, "Data de início: #{offer.decorate.format_date}",
                  class: 'mb-0')
  end

  def data(image, title, description)
    { image: image, title: title, description: description }
  end

  def employee_data
    data({ avatar: avatar(company_profile.logo,
                          'companies/company-default-logo.jpeg'),
           path: candidate_path(candidate) },
         company.name, name: employee.name, email: employee.email,
                       phone: company_profile.phone)
  end

  def candidate_data
    data({ avatar: avatar(candidate.avatar, 'users/user-default.png'),
           path: company_path(company) }, '',
         name: candidate.name, phone: candidate.phone, email: candidate.email)
  end

  def avatar(logo, path_file)
    return image_url(path_file) unless logo&.attached?

    logo
  end

  def main_content(data)
    link_to(image_tag(data[:image][:avatar],
                      class: 'avatar-100 float-left mr-2'),
            data[:image][:path]) +
      content_tag(:div, class: 'float-left pl-2 mb-3') do
        content_tag(:h5, data[:title], class: 'main-title') +
          content_tag(:h6, 'Seu contato principal é:', class: 'lead-4') +
          description(data[:description])
      end
  end

  def description(data)
    content_tag(:p, data[:name]) +
      content_tag(:p, "Telefone: #{data[:phone]}") +
      content_tag(:p, "Email: #{data[:email]}")
  end

  def msg_offer
    return '' unless offers.pending.any?

    content_tag(:div, 'Proposta realizada! Aguardando retorno do candidato.',
                class: 'alert alert-info')
  end
end
# rubocop:enable Metrics/ClassLength
