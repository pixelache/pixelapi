# frozen_string_literal: true

module Api::V1

  class PostsController < ApiController
    include Paginable
    before_action :authenticate_user!, only: %i[create update destroy]
    respond_to :json
    
    def create
      @post = Post.new(post_params)
      @post.subsite = @site if @post.subsite_id.nil? 
      if can? :create, @post
        @post.creator = current_user
        if @post.save
          render json: PostSerializer.new(@post).serializable_hash.to_json, status: 201
        else
          respond_with_errors(@post)
        end
      else
        render_403(:create, @post)
      end
    end

    def index
      if params[:festival_id]
        @festival = Festival.friendly.find(params[:festival_id])
        paginated = paginate(Post.by_festival(@festival).published.order('published_at DESC'))
        render_collection(paginated)
      else
        if params[:archive_id]
          @year = params[:archive_id]
          paginated = paginate(Post.by_site(@site).by_year(@year).published.order('published_at DESC'))
        elsif params[:project_id]
          @project = Project.friendly.find(params[:project_id])
          paginated = paginate(@project.self_and_descendants.visible.map{|x| x.posts.by_site(@site).published }.flatten.sort_by(&:published_at).reverse)
        elsif params[:residency_id]
          @residency = Residency.friendly.find(params[:residency_id])
          posts = @residency.posts.published
          posts += @residency.project.posts.published if @residency.project
          paginated = paginate(posts.flatten.uniq.sort_by{|x| x.published_at}.reverse)

        elsif params[:user_id]
          @user = User.friendly.find(params[:user_id])
          paginated = paginate(Post.by_site(@site).by_user(@user.id).published.order('published_at DESC'))
        else
          @posts = Post.by_site(@site).published.order('published_at DESC')

          if @posts.empty?
            if @site.festival
              paginated = paginate(Post.by_festival(@site.festival).published.order(published_at: :desc))
            end
          else
            paginated = paginate(@posts)
          end
        end
        render_collection(paginated)
      end
    end

    def show
      begin
        if params[:festival_id]
          @festival = Festival.friendly.find(params[:festival_id])
          @post = @festival.posts.friendly.find(params[:id])
          render json: PostSerializer.new(@post).serializable_hash.to_json, status: 200 
        end
      rescue ActiveRecord::RecordNotFound
        @post = Post.friendly.find(params[:id])
        if @post
          if @post.festival
            @festival = @post.festival
            if @festival.subsite
              if !request.host.split(/\./).include?(@festival.subsite.subdomain)
                redirect_to subdomain: @festival.subsite.subdomain unless request.xhr?
              elsif request.host.split(/\./).include?('festival')
                redirect_to subdomain: 'www' and return
              end
            elsif request.host.split(/\./).include?('festival')
              redirect_to subdomain: 'www' and return
            else
              render 'posts/show'
            end
          elsif @post.subsite != @site
            redirect_to "https://#{@post.subsite.subdomain}/posts/#{params[:id]}" unless request.xhr?
          end
        end
      end
    end

    protected

    def post_params
      params.require(:post).permit(:published, :subsite_id,
         :published_at, :image, :event_id, :residency_id, :project_id,
        #  :registration_required, :email_registrations_to, :question_description,
        #  :question_creators, :question_motivation, :email_template, :max_attendees,
        :festival_id, :add_to_newsfeed, :tag_list, post_category_ids: [],
          translations_attributes: [:id, :locale, :title, :body, :excerpt],
           photos_attributes: [:id, :filename, :title, :credit, :_destroy],
           festivaltheme_ids: [],
            attachments_attributes: [:id, :documenttype_id, :attachedfile,
              :_destroy, :year_of_publication,  :title, :description, :public])
    end

    private

    def serializer
      PostSerializer
    end
  end
end
