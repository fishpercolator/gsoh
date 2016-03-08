class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show]
  
  def index
    authorize Match
    @matches = current_user.matches
    @map_data = map_data(@matches[0..4])
  end
  
  def show
    @map_data = map_data([@match])
  end
  
  private
  
  def set_match
    @match = current_user.matches.find {|m| m.area.name == params[:area]} || not_found
    authorize @match
  end
  
  def colorgen
    @cg ||= ColorGenerator.new saturation: 0.5, lightness: 0.5
  end
  
  def map_data(matches)
    matches.map do |m|
      {
        polygon: m.area.polygon,
        name: m.area.name,
        score: m.score.to_i,
        path: match_path(area: m.area.name),
        color: matches.length > 1 ? '#' + colorgen.create_hex : '#000000'
      }
    end
  end
    
end
