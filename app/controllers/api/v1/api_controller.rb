# frozen_string_literal: true

module Api::V1
  # This is the parent API controller which the individual APIs inherit things from
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pagy::Backend
    before_action :get_locale
    before_action :get_site

    # load_and_authorize_resource except: :home
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::StatementInvalid, with: :respond_with_errors
    rescue_from ActiveRecord::RecordInvalid, with: :respond_with_errors
    rescue_from CanCan::AccessDenied, with: :render_not_authorized_response

    def home
      render json: { name: 'Pixelache API', environment: Rails.env.to_s, release: Rails.env.development? ? `git describe`.gsub(/\n/, '').gsub(/^v/, '') : '',
        gitref: Rails.env.development? ? `git rev-parse HEAD`.gsub(/\n/, '') : `cat REVISION`.gsub(/\n/, '') , migration:  ActiveRecord::Migrator.current_version }
    end

    private 
     
    def render_not_authorized_response(exception)
      Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      if current_user
        render json: { errors: [{ title: I18n.t('api.errors.error_403'), status: 403 }] }, status: 403
      else
        render json: { errors: [{ title: I18n.t('api.errors.error_401'), status: 401 }] }, status: 401
      end
    end

    def render_403(action, resource)
      raise CanCan::AccessDenied.new(I18n.t('api.errors.error_403'), action, resource)
    end

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

    def get_site
      @site = params[:site] ||= Subsite.find_by(name: 'pixelache')
    end
    
  end
  
end
    