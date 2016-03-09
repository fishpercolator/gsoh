class MatchPolicy < ApplicationPolicy
  def index?
    user
  end
  
  def show?
    user && record&.user == user
  end
  
  class Scope < Scope
    def resolve
      user.matches
    end
  end
  
end
