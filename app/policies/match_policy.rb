class MatchPolicy < ApplicationPolicy
  def index?
    user
  end
  
  def show?
    user && record&.user == user
  end  
end
