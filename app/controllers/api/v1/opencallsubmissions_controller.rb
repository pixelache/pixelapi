# frozen_string_literal: true

module Api::V1

  class OpencallsubmissionsController < ApiController
    respond_to :json

    def create
      @opencall = Opencall.friendly.find(params[:opencall_id])
      @opencallsubmission = Opencallsubmission.new(opencallsubmission_params.merge(opencall: @opencall))
      if @opencallsubmission.save
        # head :no_content
        render json: OpencallsubmissionSerializer.new(@opencallsubmission, include: [:opencallanswers]).serializable_hash.to_json, status: 201
      else
        Rails.logger.error @opencallsubmission.errors.inspect
        respond_with_errors(@opencallsubmission)
      end
    end

    protected

    def opencallsubmission_params
      params.require(:opencallsubmission).permit([:name, :opencall_id, :email, :phone, :address, :city, :postcode,
        :country, :website, opencallanswers_attributes: [:id, :answer, :attachment, :opencallquestion_id]])
    end

  end
end
    