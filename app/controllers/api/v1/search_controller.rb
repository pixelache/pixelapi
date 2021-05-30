# frozen_string_literal: true

module Api::V1

  class SearchController < ApiController
    respond_to :json

    def create
      @hits = []
      @term = params[:searchterm]
      if params[:id]
        @base = Festival.friendly.find(params[:id])
      end
      if @base
        @hits << { events: EventSerializer.new(Event.by_festival(@base.id).with_translations.advanced_search({event_translations: {name: @term, description: @term}}, false).uniq, include: Event::JSON_RELATIONS).serializable_hash  }
        @hits << { contributors: ContributorSerializer.new(Contributor.joins(:contributor_relations).where(["contributor_relations.relation_type = ? AND contributor_relations.relation_id = ?", @base.class.to_s, @base.id]).advanced_search({name: @term, bio: @term}, false), include: Contributor::JSON_RELATIONS).serializable_hash  } 
        @hits << { news: PostSerializer.new(Post.by_festival(@base.id).published.with_translations.advanced_search({post_translations: {title: @term, body: @term}}, false)).serializable_hash }
      end
      render json: @hits.to_json, status: 200

    end

  end
end
