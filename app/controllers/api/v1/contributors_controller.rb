# frozen_string_literal: true

module Api::V1

  class ContributorsController < ApiController
    include Paginable
    before_action :authenticate_user!, only: %i[create update destroy]
    respond_to :json

    def create
      @contributor = Contributor.new(contributor_params)
      if can? :create, @contributor
        if @contributor.save
          render json: ContributorSerializer.new(@contributor, include: Contributor::JSON_RELATIONS).serializable_hash.to_json, status: 201
        else
          respond_with_errors(@contributor)
        end
      else
        render_403(:create, @contributor)
      end
    end

    def destroy
      @contributor = Contributor.friendly.find(params[:id])
      if can? :destroy, @contributor
        if @contributor.destroy
          head :no_content
        else
          respond_with_errors @contributor
        end
      else
        render_403(:destroy, @contributor)
      end
    end
      
    def index
      if params[:festival_id]   # return unpaginated contributors for festivaltheme
        @festival = Festival.friendly.find(params[:festival_id])
        if params[:festivaltheme_id]
          @festivaltheme = @festival.festivalthemes.includes(:contributors).friendly.find(params[:festivaltheme_id])
          @contributors = @festivaltheme.contributors.order(:alphabetical_name)
          render json: ContributorSerializer.new(@contributors, include: Contributor::JSON_RELATIONS).serializable_hash.to_json, status: 200
        else  # return all contributors for the festival, paginated
          paginated = paginate(@festival.contributors.order(:alphabetical_name))
          render_collection(paginated, { include: Contributor::JSON_RELATIONS})
        end
      elsif params[:project_id]
        @project = Project.friendly.find(params[:project_id])
        paginated = paginate(@project.contributors.order(:alphabetical_name))
        render_collection(paginated, { include: Contributor::JSON_RELATIONS})
      elsif params[:event_id]
        @event = Event.friendly.find(params[:event_id])
        @contributors = @event.contributors.order(:alphabetical_name)
          render json: ContributorSerializer.new(@contributors, include: Contributor::JSON_RELATIONS).serializable_hash.to_json, status: 200
      else
        paginated = paginate(Contributor.all.order(:alphabetical_name))
        render_collection(paginated, { include: Contributor::JSON_RELATIONS})
        # render json: ContributorSerializer.new(@contributors, ).serializable_hash.to_json, status: 200 
      end
    end

    def show
      @contributor = Contributor.friendly.find(params[:id])
      render json: ContributorSerializer.new(@contributor, include: Contributor::JSON_RELATIONS).serializable_hash.to_json, status: 200 
      
    end
    
    def update
      @contributor = Contributor.friendly.find(params[:id])
      if can? :update, @contributor
        if @contributor.update(contributor_params)
          render json: ContributorSerializer.new(@contributor, include: Contributor::JSON_RELATIONS).serializable_hash.to_json, status: 200
        else 
          respond_with_errors @contributor
        end
      else
        render_403(:update, @contributor)
      end
    end
    
    protected

    def contributor_params
      params.require(:contributor).permit(:name, :slug, :parent_id, :image, :alphabetical_name, :bio, :website, :is_member, :user_id, project_ids: [], event_ids: [], festival_ids: [], festivaltheme_ids: [], residency_ids: [])
    end
    def serializer
      ContributorSerializer
    end
  end
end