# frozen_string_literal: true

module Api::V1

  class OpencallsController < ApiController
    respond_to :json

    
    def show
      @opencall = Opencall.friendly.find(params[:id])
      render json: OpencallSerializer.new(@opencall, include: [:opencallquestions]).serializable_hash.to_json, status: 200
    end
  end
end