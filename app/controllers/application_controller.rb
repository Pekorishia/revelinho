class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_presenter
  devise_group :users, contains: %i[candidate employee]
  rescue_from ActionController::UnpermittedParameters, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def after_sign_in_path_for(resource)
    return duplicated_login if candidate_signed_in? && employee_signed_in?
    return dashboard_candidates_path unless resource.is_a? Employee
    return dashboard_companies_path unless resource.company.pending?

    flash[:notice] = 'Preencha os dados corretamente'
    edit_company_path(resource.company)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[name cpf birthday occupation phone educational_level
               address city state country zip_code avatar]
    )
  end

  private

  def set_presenter
    @application_presenter = ApplicationPresenter.new(current_user)
    @flash_alerts = ApplicationDecorator.new(self).flash_alerts
  end

  def not_found
    render file: 'public/404.html', status: :not_found
  end

  def current_user
    current_candidate || current_employee
  end

  def duplicated_login
    sign_out current_candidate
    sign_out current_employee
    flash[:notice] = I18n.t('error_messages.duplicated_login')
    root_path
  end
end
