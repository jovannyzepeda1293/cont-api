# frozen_string_literal: true

module Internal
  # Internal::V1
  module V1
    # Internal::V1::InvoicesController
    class InvoicesController < BaseController
      def index
        render_paginated_json(invoices)
      end

      private

      def invoices
        ::Cache::Invoice.get_range(
          start_date: filter_params[:start_date],
          end_date: filter_params[:end_date]
        )
      end

      def filter_params
        params.permit(:start_date, :end_date)
      end
    end
  end
end
