class Admin::EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_admin
  layout "admin"
  def index
    @event = Event.all
  end

  def check_admin
    unless current_user.admin?
      raise ActiveRecord::RecordnotFound
      redirect_to root_path
      return
    end
  end
end

