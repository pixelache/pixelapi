# frozen_string_literal: true

module Api::V1

  class OpencallsubmissionsController < ApiController
    respond_to :json

    def create
      @opencall = Opencall.friendly.find(params[:opencall_id])
      @opencallsubmission = Opencallsubmission.new(opencallsubmission_params)
      if @opencallsubmission.save
        head :no_content
      else
        logger.error @opencallsubmission.errors
      end
    end

    protected

    def opencallsubmission_params
      params.require(:opencallsubmission).permit([:name, :opencall_id, :email, :phone, :address, :city, :postcode,
        :country, :website, opencallanswers_attributes: [:id, :answer, :attachment, :opencallquestion_id]])
    end

  end
end
    