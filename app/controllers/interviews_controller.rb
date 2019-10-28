class InterviewsController < ApplicationController
  before_action :authenticate_employee!, only: %i[new create]
  before_action :parametize, only: %i[new create]
  before_action :parametize_create, only: %i[create]
  before_action :authorize_employee!, only: %i[create]

  def new
    @formats_json = { formats: Interview.formats.map do |value, i|
      { name: I18n.t(:"format.#{value}"),
        value: value }
    end }.to_json
    @post_url = selection_process_interviews_path(@selection_process)
  end

  def create
    @interview = Interview.new(@interview_params)

    if @interview.save
      flash[:notice] = 'Solicitação enviada. Aguardando confirmação do candidato'
      redirect_to selection_process_path(
        @interview_params[:selection_process_id]
      )
    else
      flash.now[:danger] = 'Preencha todos os campos corretamente'
      render :new
    end
  end

  private

  def parametize
    @selection_process = SelectionProcess.find(params[:selection_process_id])
    @position = @selection_process.invite.position
    @candidate = @selection_process.invite.candidate
  end

  def parametize_create
    @interview_params = params.require(:interview).permit(:date, :time_to,
                                                          :time_from, :address,
                                                          :format,
                                                          :selection_process_id)
  end

  def authorize_employee!
    return if @selection_process.invite.position.company ==
              current_employee.company
    
    render json: {}, status: :forbidden
  end
end
