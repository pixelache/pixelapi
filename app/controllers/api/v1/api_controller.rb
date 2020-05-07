# frozen_string_literal: true

module Api::V1
  # This is the parent API controller which the individual APIs inherit things from
  class ApiController < ApplicationController
    before_action :get_locale
    # load_and_authorize_resource except: :home
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::StatementInvalid, with: :respond_with_errors
    
    def home
      render json: { name: 'Pixelache API', environment: Rails.env.to_s, release: Rails.env.development? ? `git describe`.gsub(/\n/, '').gsub(/^v/, '') : '',
        gitref: Rails.env.development? ? `git rev-parse HEAD`.gsub(/\n/, '') : `cat REVISION`.gsub(/\n/, '') , migration:  ActiveRecord::Migrator.current_version }
    end

    private 

    def render_not_found_response(exception)
      render json: { errors: [{ detail: exception.message, title: I18n.t('api.errors.error_404'), status: 404 }] }, status: :not_found
    end

    def respond_with_errors(exception)
      if exception.respond_to?('errors')
        # Rails.logger.error exception.errors.inspect
        message = exception.errors.full_messages.join('; ')
      elsif exception.message
        # Rails.logger.error exception.message
        message = exception.message
      else
        message = I18n.t('activerecord.errors.unknown')
      end
  
      render json: { errors: [{ title: message, status: 422 }] }, status: :unprocessable_entity
    end
    
    def get_locale 
      if params[:locale]
        I18n.locale = params[:locale]
      else
        available  = %w{en fi}
        I18n.locale = http_accept_language.compatible_language_from(available)
      end
    end
  end
  
end
    