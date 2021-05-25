# frozen_string_literal: true

module Api::V1

  class AttendeesController < ApiController
    def create
      if params[:event_id]
        @item = Event.friendly.find(params[:event_id])
        @attendee = Attendee.new(permitted_params)
        if @item.is_full?
          @attendee.waiting_list = true
        end
        @item.attendees << @attendee
      end
      # if params[:post_id]
      #   begin
      #     @item = @site.posts.friendly.find(params[:post_id])

      #   rescue ActiveRecord::RecordNotFound
      #     if @site.festival
      #       @item = @site.festival.posts.friendly.find(params[:post_id])
      #     end
      #   end
      #   @attendee = Attendee.new(permitted_params)
      #   if @item.is_full?
      #     @attendee.waiting_list = true
      #   end
      #   @item.attendees << @attendee
      # end

      if verify_hcaptcha
        if @item.save
          AttendeeMailer.registration_notification(@attendee).deliver_now
          AttendeeMailer.enduser_notification(@attendee).deliver_now
          head :no_content
        else
          Rails.logger.error @attendee.errors.inspect 
          
          respond_with_errors(@attendee)
        end
      else
        render json: { errors: [{ title: 'Error: invalid CAPTCHA', status: 422 }] }, status: :unprocessable_entity
      end
    end

    protected
  
    def permitted_params
      params.require(:attendee).permit(:name, :phone, :email, :motivation_statement, :project_creators, :project_description)
    end
  
  end
end