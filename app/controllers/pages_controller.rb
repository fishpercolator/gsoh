class PagesController < ApplicationController
  # All the 'pages' are not authorized
  skip_after_action :verify_authorized
  
  include HighVoltage::StaticPage
end
