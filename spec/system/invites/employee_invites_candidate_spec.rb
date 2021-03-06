require 'rails_helper'

feature 'Invites' do
  scenario 'Employee invites candidate to position' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)
    create(:position, title: 'Engenheiro de Software Pleno',
                      company: company)
    mail = double
    allow(InviteMailer).to receive(:notify_candidate).and_return(mail)
    allow(mail).to receive(:deliver_now)

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    select 'Engenheiro de Software Pleno', from: 'Posição'
    fill_in 'invite-message', with: 'Olá, ser humano. ' \
    'Venha fazer parte do nosso time'
    click_on 'Convidar'

    candidate.reload

    invite_id = candidate.invites.last.id
    expect(InviteMailer).to have_received(:notify_candidate).with(invite_id)
    expect(page).to have_content('Gustavo convidado com sucesso para ' \
    'Engenheiro de Software Pleno')
    expect(candidate.invites.count).to eq(1)
    expect(current_path).to eq(candidates_path)
  end

  scenario 'Employee sees invited candidates in candidates list' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)
    position = create(:position, title: 'Engenheiro de Software Pleno',
                                 company: company)
    create(
      :invite,
      candidate: candidate,
      position: position,
      message: 'Olá, ser humano. Venha fazer parte do nosso time'
    )

    login_as(employee, scope: :employee)
    visit candidates_path

    within "#candidate-#{candidate.id}" do
      expect(page).to have_content('Aguardando aceite de convite')
    end
  end

  scenario 'Employee sees existing invite in candidate page' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, :with_candidate_profile, name: 'Gustavo')
    position = create(:position, title: 'Engenheiro de Software Pleno',
                                 company: company)
    create(
      :invite,
      candidate: candidate,
      position: position,
      message: 'Olá, ser humano. Venha fazer parte do nosso time'
    )

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    expect(page).to have_content('Candidato convidado para:')
    expect(page).to have_content(position.title)
  end

  scenario 'Employee only invite candidate once per position' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)
    position_invited = create(:position, title: 'Engenheiro de Software Pleno',
                                         company: company)
    position_available = create(:position, title: 'Engenheiro de Sistemas',
                                           company: company)
    create(
      :invite,
      candidate: candidate,
      position: position_invited,
      message: 'Olá, ser humano. Venha fazer parte do nosso time'
    )

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    expect(page).to have_select('Posição', options: [position_available.title])
    expect(page).not_to have_select(
      'Posição',
      with_options: [position_invited.title]
    )
  end

  scenario 'Employee can only invite candidates to his company\'s positons' do
    company_contractor = create(:company, url_domain: 'revelo.com.br')
    company_other = create(:company, url_domain: 'jobs.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company_contractor)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)
    position_contractor = create(:position,
                                 title: 'Engenheiro de Software Pleno',
                                 company: company_contractor)
    position_other = create(:position, title: 'Engenheiro de Sistemas',
                                       company: company_other)

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    expect(page).to have_select(
      'Posição',
      options: [position_contractor.title]
    )
    expect(page).not_to have_select(
      'Posição',
      with_options: [position_other.title]
    )
  end

  scenario 'Employee invites candidate to second position' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)
    create(:position, title: 'Engenheiro de Software Pleno',
                      company: company)
    position = create(:position, title: 'Engenheiro de Sistemas',
                                 company: company)
    create(
      :invite,
      candidate: candidate,
      position: position,
      message: 'Olá, ser humano. Venha fazer parte do nosso time'
    )

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    select 'Engenheiro de Software Pleno', from: 'Posição'
    fill_in 'invite-message', with: 'Olá, ser humano. ' \
    'Venha fazer parte do nosso time'
    click_on 'Convidar'

    candidate.reload
    expect(page).to have_content('Gustavo convidado com sucesso para ' \
    'Engenheiro de Software Pleno')
    expect(candidate.invites.count).to eq(2)
    expect(current_path).to eq(candidates_path)
  end

  scenario 'Employee sees position link when there are none ' \
  'to invite a candidate to' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    create(:candidate_profile, candidate: candidate)

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)

    expect(page).to have_link('Adicionar posição', href: new_position_path)
    expect(page).to have_button('Convidar', disabled: true)
  end

  scenario 'Employee fails to invite candidate to position' do
    company = create(:company, url_domain: 'revelo.com.br')
    employee = create(:employee, email: 'renata@revelo.com.br',
                                 company: company)
    candidate = create(:candidate, name: 'Gustavo')
    position = create(:position, title: 'Engenheiro de Software Pleno',
                                 company: company)
    create(:candidate_profile, candidate: candidate)

    invite_double = double('invites')
    allow(Candidate).to receive(:find).and_return(candidate)
    allow(candidate).to receive(:invites).and_return(invite_double)
    allow(invite_double).to receive(:build).and_return(invite_double)
    allow(invite_double).to receive(:pending).and_return(invite_double)
    allow(invite_double).to receive(:each).and_return(position)
    allow(invite_double).to receive(:save).and_return(false)

    login_as(employee, scope: :employee)
    visit candidate_path(candidate)
    select 'Engenheiro de Software Pleno', from: 'Posição'
    fill_in 'invite-message', with: 'Olá, ser humano. ' \
    'Venha fazer parte do nosso time'

    click_on 'Convidar'

    expect(page).to have_content('Erro ao tentar convidar candidato')
    expect(Invite.count).to eq(0)
    expect(current_path).to eq(candidate_path(candidate))
  end
end
