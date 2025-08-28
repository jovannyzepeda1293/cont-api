# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cache::Base do
  describe 'abstract methods' do
    it 'raises NotImplementedError for index_key' do
      expect { described_class.index_key }
        .to raise_error(NotImplementedError, /missing `self.index_key` method/)
    end

    it 'raises NotImplementedError for expires_in' do
      expect { described_class.expires_in }
        .to raise_error(NotImplementedError, /missing self.expires_in method/)
    end

    it 'raises NotImplementedError for fetch_range_from_db' do
      expect { described_class.fetch_range_from_db(from: Date.today, to: Date.today) }
        .to raise_error(NotImplementedError, /missing self.fetch_range_from_db method/)
    end

    it 'raises NotImplementedError for cacheable_params' do
      expect { described_class.cacheable_params }
        .to raise_error(NotImplementedError, /missing self.cacheable_params method/)
    end
  end
end
