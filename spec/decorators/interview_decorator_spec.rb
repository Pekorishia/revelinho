require 'rails_helper'

describe InterviewDecorator do
  context '#format_datetime' do
    it 'shows datetime formated correctly' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview,
                         datetime: '2019-10-26 17:00:00',
                         format: :face_to_face,
                         address: 'Av. Paulista, 2000',
                         selection_process: selection_process).decorate

      expect(interview.format_datetime).to eq 'Dia 26/10/2019 às 17:00'
    end
  end
  context '#decision_buttons' do
    it 'shows decision buttons if invite is pending' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview,
                         datetime: '2019-10-26 17:00:00',
                         format: :face_to_face,
                         address: 'Av. Paulista, 2000',
                         selection_process: selection_process,
                         status: :pending).decorate

      expect(interview.decision_buttons).to(include 'Aceitar')
      expect(interview.decision_buttons).to(include 'Recusar')
    end
    it 'shows returns nothing buttons if invite is not pending' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview, datetime: '2019-10-26 17:00:00',
                                     format: :face_to_face,
                                     address: 'Av. Paulista, 2000',
                                     selection_process: selection_process,
                                     status: :scheduled).decorate

      expect(interview.decision_buttons).to eq ''
    end
  end
  context '#interview_status_badge' do
    it 'shows pending_badge correctly' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview,
                         datetime: '2019-10-26 17:00:00',
                         format: :face_to_face,
                         address: 'Av. Paulista, 2000',
                         selection_process: selection_process,
                         status: :pending).decorate

      expect(interview.interview_status_badge).to(
        include 'Aguardando resposta'
      )
    end
    it 'shows scheduled_badge correctly' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview,
                         datetime: '2019-10-26 17:00:00',
                         format: :face_to_face,
                         address: 'Av. Paulista, 2000',
                         selection_process: selection_process,
                         status: :scheduled).decorate

      expect(interview.interview_status_badge).to(
        include 'Entrevista agendada'
      )
    end
    it 'shows canceled_badge correctly' do
      company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
      company.company_profile = create(:company_profile)
      candidate = create(:candidate, status: :published)
      create(:employee, email: 'joao@revelo.com.br', company: company)
      position = create(:position, company: company)
      invite = create(:invite, candidate: candidate, position: position,
                               status: :pending)
      selection_process = invite.create_selection_process
      interview = create(:interview,
                         datetime: '2019-10-26 17:00:00',
                         format: :face_to_face,
                         address: 'Av. Paulista, 2000',
                         selection_process: selection_process,
                         status: :canceled).decorate

      expect(interview.interview_status_badge).to(
        include 'Entrevista cancelada'
      )
    end
  end
end
