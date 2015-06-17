class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, :only => [:show, :edit, :update, :destroy, :dashboard]
  private
  def set_event
    @event = Event.find(params[:id])
  end
  def event_params
    params.require(:event).permit(:name, :description, :category_id, :status, :group_ids => [])
  end

  public
  # GET /events/index
  # GET /events
  def index
    if params[:eid]
      @event = Event.find( params[:eid])
    else
      @event = Event.new
      # @event.start_on = Date.new(2015,1,1)
    end
    prepare_variable_for_index_template

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
  # GET /events/:id/dashboard
  def dashboard

  end
  def latest
    @events =Event.order("id DESC").limit(3)

  end
  # POST /event.bulk_delete
  def bulk_update
    ids = Array( params[:ids])
    events = ids.map{ |i| Event.find_by_id(i)}.compact
    if params[:commit] == "Delete"
      events.each { |event| event.destroy}
    elsif params[:commit] =="Publish"
      events.each {|event| event.update( :status => "published")}
    end
    redirect_to :back
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
      render :action => :new
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
  def prepare_variable_for_index_template
    if params[:keyword]
      @events = Event.where( ["name like ?", "%#{params[:keyword]}%"])
    else
      @events = Event.all
    end

    if params[:order]
      sort_by = (params[:order] == "name") ? "name" : "id"
      @events = @events.order(sort_by)

    end
    @events = @events.page( params[:page]).per(10)
  end
end
