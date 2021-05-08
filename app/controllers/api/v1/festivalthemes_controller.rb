# frozen_string_literal: true

module Api::V1

  class FestivalthemesController < ApiController
    respond_to :json

    def index
      @festival = Festival.friendly.find(params[:festival_id])
      @festivalthemes = @festival.festivalthemes
      render json: FestivalthemeSerializer.new(@festivalthemes).serializable_hash.to_json, status: 200 
    end
    

    def show
      @festival = Festival.friendly.find(params[:festival_id])
      @festivaltheme = @festival.festivalthemes.friendly.find(params[:id])
      render json: FestivalthemeSerializer.new(@festivaltheme).serializable_hash.to_json, status: 200 
    end
  end
end
    