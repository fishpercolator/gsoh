class MatchPolicy < ApplicationPolicy
  def index?
    user
  end
end
