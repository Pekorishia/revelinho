Candidate.create!(email: 'paulo.antonio@candidato.com', password: '123456',
                  name: 'Paulo antonio', cpf: '1234567890', status: :published,
                  address: 'Rua Revelada, 10', phone: '(11) 98238-2341',
                  occupation: 'full stack developer', city: 'São Paulo',
                  state: 'São Paulo', country: 'Brasil', zip_code: '03141-030',
                  birthday: '12/04/1991', educational_level: 'mestrado')

Candidate.create!(email: 'jose.pedro@candidato.com', password: '123456',
                  name: 'José Pedro', cpf: '1234567890', status: :published,
                  address: 'Rua Revelada, 10', phone: '(11) 98238-2341',
                  occupation: 'full stack developer', city: 'São Paulo',
                  state: 'São Paulo', country: 'Brasil', zip_code: '03141-030',
                  birthday: '12/04/1991', educational_level: 'mestrado')

Candidate.all.each do |candidate|
  CandidateProfile.create!(
    work_experience: 'Sou rubysta master',
    education: 'mestrado concluído',
    skills: 'Node, React, Rails',
    coding_languages: 'Javascript, ruby',
    english_proficiency: 'Fluente',
    skype_username: 'candidate',
    linkedin_profile_url: 'candidate',
    github_profile_url: 'candidate',
    candidate: candidate
  )  
end
                  

company = Company.create!(name: 'Revelo', url_domain: 'revelo.com.br')
Employee.create!(email: "joao.silva@revelo.com.br",
                 password: '123456', company: company)

company.positions.create!(title: 'Desenvolvedor', industry: 'Tecnologia',
                 description: 'Desenvolvedor fullstack em Ruby',
                 salary: 3000.00, position_type: 'full_time')

Invite.create!(candidate: Candidate.last, position: Position.last,
               status: :accepted)
selection_process = Invite.last.create_selection_process

Message.create!(sendable: Candidate.first, selection_process: selection_process,
                text: 'Olá, obrigado pelo convite.')
Message.create!(sendable: Employee.first, selection_process: selection_process,
                text: 'Olá! Adoramos o seu perfil, '\
                      'podemos marcar uma entrevista?')

