# frozen_string_literal: true

module Api::V1

  class ResidenciesController < ApiController
    include Paginable
    before_action :authenticate_user!, only: %i[create update destroy]
    respond_to :json

    def create
      @residency = Residency.new(residency_params)
      if can? :create, @residency
        if @residency.save
          render json: serializer.new(@residency).serializable_hash.to_json, status: 201
        else
          respond_with_errors(@residency)
        end
      else
        render_403(:create, @residency)
      end
    end

    def index
      paginated = paginate(Residency.all.order(:start_at))
      render_collection(paginated)
    end

    def update
      @residency = Residency.friendly.find(params[:id])
      if can? :update, @residency
        if @residency.update(residency_params)
          render json: serializer.new(@residency).serializable_hash.to_json, status: 200
        else 
          respond_with_errors @residency
        end
      else
        render_403(:update, @residency)
      end
    end
    
    protected

    def residency_params
      params.require(:residency).permit(:name, :country, :country_override, :project_id, :user_id, :photo, :is_micro, :start_at, :end_at,
        translations_attributes: [:description, :id, :locale, :_destroy])
    end
    
    private

    def serializer
      ResidencySerializer
    end
  end
end