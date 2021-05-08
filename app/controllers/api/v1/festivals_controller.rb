# frozen_string_literal: true

module Api::V1

  class FestivalsController < ApiController
    respond_to :json

    def page
      @festival = Festival.friendly.find(params[:id])
      if params[:page] =~ /\//
        p = params[:page].split(/\//).last
      else
        p = params[:page]
      end
      potential = p =~ /^\d+$/ ? Page.where(:id => p) : Page.where(:slug => p)
      @page = @festival.pages.map(&:self_and_descendants).flatten.delete_if{|x| !potential.include?(x) }.first
      if @page.nil?
        raise ActiveRecord::RecordNotFound
      end
      unless @page.friendly_id == params[:page]
        redirect_me = true 
      end
      if @festival.subsite
        if !request.host.split(/\./).include?(@festival.subsite.subdomain)
          redirect_me = true        
        end
      end
      if redirect_me == true && @festival.subsite
        # redirect_to action: action_name, id: @festival.friendly_id, page: @page.friendly_id, status: 301
        redirect_to festival_page_festival_url(@festival.slug, @page.friendly_id, subdomain: @festival.subsite.subdomain) and return
      else
        render json: PageSerializer.new(@page).serializable_hash.to_json, status: 200
      end
    end

    def index
      @festivals = Festival.published
      render json: FestivalSerializer.new(@festivals).serializable_hash.to_json, status: 200 
    end
    

    def show
      @festival = Festival.friendly.find(params[:id])
      render json: FestivalSerializer.new(@festival).serializable_hash.to_json, status: 200 
    end
  end
end
    