class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show]

  def index
    @candidates = Candidate.published
    msg = 'Não há candidatos cadastrados até agora'
    flash[:notice] = msg if @candidates.empty?
  end

  def show
    @notes = Company.select('candidate_notes.id, ' \
      'employees.email as employee_email, ' \
      'candidate_notes.comment').joins(employees: :candidate_notes).where(
        id: current_employee.company.id
      )
  end

  def add_comment
    candidate_note = CandidateNote.new(
      comment: params.require(:comment),
      employee: current_employee
    )
    candidate = Candidate.find(params[:candidate_id])
    candidate.candidate_notes << candidate_note
    redirect_to candidate
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end
