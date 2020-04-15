# frozen_string_literal: true

module Api::V1
  # This is the parent API controller which the individual APIs inherit things from
  class ApiController < ApplicationController
    before_action :get_locale
    # load_and_authorize_resource except: :home

    def home
      render json: { name: 'Pixelache API', environment: Rails.env.to_s, release: Rails.env.development? ? `git describe`.gsub(/\n/, '').gsub(/^v/, '') : '',
        gitref: Rails.env.development? ? `git rev-parse HEAD`.gsub(/\n/, '') : `cat REVISION`.gsub(/\n/, '') , migration:  ActiveRecord::Migrator.current_version }
    end

    private 

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
    