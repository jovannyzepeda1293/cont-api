# frozen_string_literal: true

module Cache
  # Cache::Base
  class Base
    class << self
      def index_key
        raise NotImplementedError, 'missing `self.index_key` method'
      end

      def expires_in
        raise NotImplementedError, 'missing self.expires_in method'
      end

      def fetch_range_from_db(from:, to:)
        raise NotImplementedError, 'missing self.fetch_range_from_db method'
      end

      def cacheable_params
        raise NotImplementedError, 'missing self.cacheable_params method'
      end

      def get_range(start_date:, end_date:)
        validate_date_range!(start_date:, end_date:)
        start_date = Time.parse(start_date).at_beginning_of_day
        end_date = Time.parse(end_date).at_end_of_day

        cache_key = "#{index_key}:range:#{start_date.to_i}-#{end_date.to_i}"

        Rails.cache.fetch(cache_key, expires_in: expires_in.minutes) do
          fetch_range_from_db(start_date:, end_date:).map do |record|
            record.slice(:id, *cacheable_params).as_json
          end
        end
      end

      private

      def validate_date_range!(start_date:, end_date:)
        range = DateRange.new(start_date:, end_date:)
        return if range.valid?

        raise ArgumentError, range.errors.full_messages.join(', ')
      end
    end
  end
end
