# frozen_string_literal: true

module Cache
  # Cache::Invoice
  class Invoice < Base
    class << self
      CACHEABLE_PARAMS = %w[invoice_number total invoice_date status active].freeze

      def index_key
        'invoices'
      end

      def fetch_range_from_db(start_date:, end_date:)
        ::Invoice.where(invoice_date: start_date..end_date)
      end

      def expires_in
        ENV.fetch('EXPIRE_INVOICES_TTL', 10).to_i
      end

      def cacheable_params
        CACHEABLE_PARAMS
      end
    end
  end
end
