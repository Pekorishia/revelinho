class PositionsController < ApplicationController
  before_action :authenticate_employee!, only: %i[ create]

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    @position.company = current_employee.company
    if @position.save
      redirect_to @position
    else
      render :new
    end
  end

  def show
    @position = Position.find(params[:id])
  end

  private 
  
  def position_params
    params.require(:position).permit(:title, :industry, :salary, :position_type, :description)
  end
end
