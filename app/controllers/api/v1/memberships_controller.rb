# frozen_string_literal: true

module Api::V1

  class MembershipsController < ApiController
    include Paginable
    respond_to :json
    has_scope :year
    has_scope :paid, type: :boolean

    def serializer
      MembershipSerializer
    end

    def index
      paginated = paginate(apply_scopes(Membership.joins(:user)))
      render_collection(paginated, {include: [:user]})
    end
  end
end
