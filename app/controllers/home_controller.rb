class HomeController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped
  def index
    @answer = Question.random.answer
  end
end
