class Admin::EventsController < ApplicationController

  layout "admin"
  def index
    @event = Event.all
  end
end

