class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show]
  
  def index
    authorize Match
    @matches = current_user.matches
  end
  
  def show
  end
  
  private
  
  def set_match
    console
    @match = current_user.matches.find {|m| m.area.name == params[:area]} || not_found
    authorize @match
  end
  
end
