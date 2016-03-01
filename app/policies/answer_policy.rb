class AnswerPolicy < ApplicationPolicy
  # Users can only create/update answers they own
  def create?
    user == record.user
  end
  def update?
    create?
  end
end
