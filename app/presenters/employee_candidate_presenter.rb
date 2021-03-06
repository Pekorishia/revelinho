class EmployeeCandidatePresenter < SimpleDelegator
  include ActionView::Helpers::OutputSafetyHelper

  attr_reader :candidate, :employee

  delegate :content_tag, :link_to, to: :h

  def initialize(candidate, employee)
    @candidate = candidate
    @employee = employee
    super(candidate)
  end

  def self.decorate_collection(candidates, employee)
    candidates.map { |candidate| new(candidate, employee) }
  end

  def invited_positions
    positions = []
    candidate.invites.pending.each do |i|
      positions << i.position if i.company == employee.company
    end
    positions
  end

  def uninvited_positions
    employee.company.positions.where.not(id: candidate.positions.ids)
  end

  def no_invitable_positions?
    uninvited_positions.empty?
  end

  def awaiting_invites_badge
    return '' if invited_positions.empty?

    content_tag(
      :span,
      'Aguardando aceite de convite',
      class: 'badge badge-info'
    )
  end

  def invited_positions_card
    return '' unless invited_positions.any?

    content_tag(:p, 'Candidato convidado para:') +
      content_tag(:ul) do
        safe_join(invited_positions.map { |p| content_tag(:li, p.title) })
      end
  end

  private

  def h
    ApplicationController.helpers
  end
end
