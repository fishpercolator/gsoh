class AnswerPolicy < ApplicationPolicy
  # Just need to be signed in to create a new answer
  def new?
    user
  end
  # Users can only create/update answers they own
  def create?
    user == record.user
  end
  def update?
    create?
  end
end
