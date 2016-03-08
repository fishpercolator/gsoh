class AnswerPolicy < ApplicationPolicy
  # Any user can list their answers
  def index?
    user # FIXME Scope
  end
  
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
end
