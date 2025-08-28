# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:invoice_number) }
    it { should validate_presence_of(:invoice_date) }
    it { should validate_presence_of(:total) }
    it { should validate_uniqueness_of(:invoice_number) }
    it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  end
end
