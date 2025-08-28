# frozen_string_literal: true

# ApiPagination
module ApiPagination
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  private

  def render_paginated_json(records)
    @pagy, @paginated = pagy_array(records)

    render :index
  end
end
