class MatchesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    authorize Match
    @matches = current_user.matches
  end
end
