# frozen_string_literal: true

module Api::V1

  class ProjectsController < ApiController
    include Paginable
    before_action :authenticate_user!, only: %i[create update destroy]
    respond_to :json
    has_scope :roots, type: :boolean

    def create
      @project = Project.new(project_params)
      if can? :create, @project
        if @project.save
          render json: serializer.new(@project).serializable_hash.to_json, status: 201
        else
          respond_with_errors(@project)
        end
      else
        render_403(:create, @project)
      end
    end

    def show
      @project = Project.find(params[:id])
      render json: serializer.new(@project).serializable_hash.to_json, status: 200
    end

    def index
      paginated = paginate(apply_scopes(Project.visible))
      render_collection(paginated)
    end

    def update
      @project = Project.friendly.find(params[:id])
      if can? :update, @project
        if @project.update(project_params)
          render json: serializer.new(@project).serializable_hash.to_json, status: 200
        else 
          respond_with_errors @project
        end
      else
        render_403(:update, @project)
      end
    end
    
    protected

    def project_params
      params.require(:project).permit(:name, :slug, :parent_id, :evolvedfrom_id, :hidden, :project_bg_colour,
       :project_text_colour, :project_link_colour, :redirect_to, :background, :remove_background,
        :evolution_year, :has_listserv, :listservname, :website, :active, 
        translations_attributes: [:description, :short_description, :id, :locale], 
        photos_attributes: [:id, :filename, :_destroy], 
        videos_attributes: [:id, :in_url, :_destroy], 
        attachments_attributes: [:id, :year_of_publication, :attachedfile,:title, :description, :public, :item_type, 
          :item_id, :documenttype_id,  :_destroy])
    end
    
    private

    def serializer
      ProjectSerializer
    end
  end
end