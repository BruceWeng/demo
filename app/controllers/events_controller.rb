class EventsController < ApplicationController
  before_action :set_event, :only => [:show, :edit, :update, :destroy]
  # GET /events/index
  # GET /events
  def index
    @events = Event.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xml {
        render :xml => @events.to_xml
      }
      format.json {
        render :json => @events.to_json
      }
      format.atom {
        @feed_title = "My event list"
      }
    end
  end
  # GET /events
  def show
    @page_title = @event.name
    respond_to do |format|
      format.html { @page_title = @event.name } # show.html.erb
      format.xml # show.xml.builder
      format.json { render :json => { id: @event.id, name: @event.name }.to_json }
    end
  end
  # GET /events/new
  def new
    @event = Event.new
  end
  # POST /events
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "Successfully created!"
      # Do not what confirmation alert
      redirect_to events_path #Tell browser HTTP code: 303
    else
      render :action => :new # new.html.erb
    end
  end
  # GET /events/:id/edit
  def edit
  end
  # PATCH /events/:id
  def update
    if @event.update(event_params)
      flash[:notice] = "event was successfully updated!"
      redirect_to event_path(@event)
    else
      render :action => :edit # edit.html.erb
    end
  end
  # DELETE /events/destroy/:id
  def destroy
    @event.destroy
    flash[:alert] = "event was successfully deleted"
    redirect_to events_path
  end
  private
  def set_event
    @event = Event.find(params[:id])
  end
  def event_params
    params.require(:event).permit(:name, :description)
  end
end