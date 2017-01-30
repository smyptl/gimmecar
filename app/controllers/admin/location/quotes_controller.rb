class Admin::Location::QuotesController < Admin::BaseController

  before_action :authenticate_user, :authenticate_location

  def index
  end
end
