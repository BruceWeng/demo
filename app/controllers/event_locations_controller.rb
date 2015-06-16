class EventLocationsController < ApplicationController
  before_action :find_event

  def show
    @location = @event.location
  end

  def show
    @location =@event.location
  end

  def new
    @location = @event.build_location
  end

  def create
    @location =@event.build_locaition( location_params)
    if @location.save
      redirect_to event_location_url (@event)
    else
      render :action => :new
    end
  end

  def update
    @location =@event.location
    if @location.update( location_params)
      redirect_to event_location_url( @event)
    else
      render :action => :edit
    end
  end

  protected

  def find_event
    @event =Event.find(params[:id])
  end

  def location_params
    params.require(:location). permit(:name)
  end
end
