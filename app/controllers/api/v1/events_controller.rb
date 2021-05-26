# frozen_string_literal: true

module Api::V1

    class EventsController < ApiController
      before_action :authenticate_user!, only: %i[create update destroy]
      respond_to :json
      has_scope :by_date
  
      def create
        @event = Event.new(event_params)
        if can? :create, @event
          if @event.save
            render json: EventSerializer.new(@event).serializable_hash.to_json, status: 201
          else
            respond_with_errors(@event)
          end
        else
          render_403(:create, @event)
        end
      end
  
      def index
        if params[:festival_id]
          @festival = Festival.friendly.includes(:festivalthemes).find(params[:festival_id])
          @events = apply_scopes(@festival.events.includes([:festivalthemes, contributor_relations: :contributor], :festivalthemes)).order(:start_at, :slug, :end_at) #.published
        else
          @events = apply_scopes(Event).published
        end
        render json: EventSerializer.new(@events, include: Event::JSON_RELATIONS).serializable_hash.to_json, status: 200 
      end
  
  
      def show
        if params[:festival_id]
          @festival = Festival.friendly.find(params[:festival_id])
          @event = @festival.events.friendly.includes(:place).find(params[:id])
        else
          @event = Event.published.friendly.find(params[:id])
        end
        render json: EventSerializer.new(@event, include: Event::JSON_RELATIONS).serializable_hash.to_json, status: 200 
      end

      def update
        @event = Event.friendly.find(params[:id])
        if can? :update, @event
          if @event.update(event_params)
            render json: EventSerializer.new(@event).serializable_hash.to_json, status: 200
          else 
            respond_with_errors @event
          end
        else
          render_403(:update, @event)
        end
      end
      
      protected
  
      def event_params
        params.require(:event).permit(:name, :slug, :parent_id, :evolvedfrom_id, :hidden, :event_bg_colour,
         :event_text_colour, :event_link_colour, :redirect_to, :background, :remove_background,
          :evolution_year, :has_listserv, :listservname, :website, :active, 
          translations_attributes: [:description, :short_description, :id, :locale], 
          photos_attributes: [:id, :filename, :_destroy], 
          videos_attributes: [:id, :in_url, :_destroy], 
          attachments_attributes: [:id, :year_of_publication, :attachedfile,:title, :description, :public, :item_type, 
            :item_id, :documenttype_id,  :_destroy])
      end
      
    end
  end