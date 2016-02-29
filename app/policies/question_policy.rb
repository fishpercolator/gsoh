class QuestionPolicy < ApplicationPolicy
  # Anyone can get a view of all questions if they're signed in
  def index?
    user
  end
  def show?
    user
  end
end
