require 'rails_helper'

describe 'employee has limited access' do
  context 'to company' do
    it 'and see only your company dashboard' do
      company = create(:company, name: 'Revelo', address: 'Av. Paulista',
                                 url_domain: 'revelo.com.br', status: :active)
      employee = create(:employee, email: 'joao.silva@revelo.com.br',
                                   company: company)

      login_as(employee, scope: :employee)

      get company_path(employee.company)

      expect(response.body).to include(company.name)
    end

    it 'and can not edit other companies' do
      other_company = create(:company, name: 'WeWork', address: 'Av. Paulista',
                                       url_domain: 'wework.com.br')

      company = create(:company, name: 'Revelo', address: 'Av. Paulista',
                                 url_domain: 'revelo.com.br', status: :active)
      employee = create(:employee, email: 'joao.silva@revelo.com.br',
                                   company: company)

      login_as(employee, scope: :employee)

      get edit_company_path(other_company)

      expect(response).to redirect_to(company_path(company))
    end

    it 'and can not update other companies' do
      other_company = create(:company, name: 'WeWork', address: 'Av. Paulista',
                                       url_domain: 'wework.com.br')

      company = create(:company, name: 'Revelo', address: 'Av. Paulista',
                                 url_domain: 'revelo.com.br', status: :active)
      employee = create(:employee, email: 'joao.silva@revelo.com.br',
                                   company: company)

      login_as(employee, scope: :employee)

      patch company_path(other_company),
            params: { company: { name: 'Campus code',
                                 address: 'Av Paulista 2' } }

      expect(response).to redirect_to(company_path(company))
    end

    it 'and cannot access other page until fix company profile' do
      company = create(:company, status: :pending)
      employee = create(:employee, email: 'employee@company.com',
                                   company: company)
      login_as(employee)

      get company_path(company)

      expect(response).to redirect_to(edit_company_path(company))
    end
  end
end
