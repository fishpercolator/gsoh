class AnswerPolicy < ApplicationPolicy  
  # Users can only create/update answers they own
  def create?
    user == record.user
  end
  def update?
    create?
  end
  def new?
    create?
  end
  
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end  
end
