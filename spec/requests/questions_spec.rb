require 'rails_helper'

RSpec.describe "Questions", type: :request do
  describe "GET /questions" do
    it 'gets a list of questions' do
      pending 'Need to write these specs'
      get questions_path
      expect(response).to have_http_status(200)
    end
  end
end
