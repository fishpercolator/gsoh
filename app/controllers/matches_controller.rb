class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show]
  
  def index
    @matches = policy_scope(Match)
  end
  
  def show
    @closest_nns = @match.area.closest('nns')
  end
  
  private
  
  def set_match
    area = Area.find_by(name: params[:area]) || not_found
    @match = current_user.matches.where(area: area).first || not_found
    authorize @match
  end
    
end
