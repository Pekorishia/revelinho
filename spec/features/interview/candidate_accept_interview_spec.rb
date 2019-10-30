require 'rails_helper'

feature 'candidate see interview invite' do
  scenario 'successfully' do
    company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
    company.company_profile = create(:company_profile)
    candidate = create(:candidate, status: :published)
    create(:employee, email: 'joao@revelo.com.br', company: company)
    position = create(:position, company: company)
    invite = create(:invite, candidate: candidate, position: position,
                             status: :pending)
    selection_process = invite.create_selection_process
    create(:interview, datetime: '2019-10-26 17:00:00',
                       format: :face_to_face,
                       address: 'Av. Paulista, 2000',
                       selection_process: selection_process)

    login_as(candidate, scope: :candidate)
    visit selection_process_candidates_path(selection_process)

    expect(page).to have_content('Entrevistas')
    expect(page).to have_content('26 de outubro de 2019, 17:00')
    expect(page).to have_content('Endereço: Av. Paulista, 2000')
    expect(page).to have_content('Formato: Presencial')
    expect(page).to have_content('Aguardando resposta')
    expect(page).to have_link('Aceitar')
    expect(page).to have_link('Recusar')
  end

  scenario 'and accept' do
    company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
    company.company_profile = create(:company_profile)
    candidate = create(:candidate, status: :published)
    create(:employee, email: 'joao@revelo.com.br', company: company)
    position = create(:position, company: company)
    invite = create(:invite, candidate: candidate, position: position,
                             status: :pending)
    selection_process = invite.create_selection_process
    create(:interview, datetime: '2019-10-26 17:00:00',
                       format: :face_to_face,
                       address: 'Av. Paulista, 2000',
                       selection_process: selection_process)

    login_as(candidate, scope: :candidate)
    visit selection_process_candidates_path(selection_process)
    click_on 'Aceitar'

    expect(page).to have_content('Entrevista agendada')
    expect(page).not_to have_link('Aceitar')
    expect(page).not_to have_link('Recusar')
  end

  scenario 'and reject' do
    company = create(:company, name: 'Revelo', url_domain: 'revelo.com.br')
    company.company_profile = create(:company_profile)
    candidate = create(:candidate, status: :published)
    create(:employee, email: 'joao@revelo.com.br', company: company)
    position = create(:position, company: company)
    invite = create(:invite, candidate: candidate, position: position,
                             status: :pending)
    selection_process = invite.create_selection_process
    create(:interview, datetime: '2019-10-26 17:00:00',
                       format: :face_to_face,
                       address: 'Av. Paulista, 2000',
                       selection_process: selection_process)

    login_as(candidate, scope: :candidate)
    visit selection_process_candidates_path(selection_process)
    click_on 'Recusar'

    expect(page).to have_content('Entrevista cancelada')
    expect(page).not_to have_link('Aceitar')
    expect(page).not_to have_link('Recusar')
  end
end