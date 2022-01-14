module Paginable
  extend ActiveSupport::Concern

  def paginate(collection)
    paginator.call(
      collection,
      params: pagination_params,
      base_url: request.url
    )
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit(page: [:number,  :size])[:page]
  end

  def render_collection(paginated, options = {})
    options.merge!({
        meta: paginated.meta.to_h,
        links: paginated.links.to_h
      })
    Rails.logger.error options.inspect
    result = serializer.new(paginated.items, options)
    render json: result, status: :ok
  end
end