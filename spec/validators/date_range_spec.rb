# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateRange, type: :model do
  describe 'validations' do
    subject(:range) { described_class.new(start_date:, end_date:) }
    let(:start_date) { '2025-08-27' }
    let(:end_date) { '2025-08-28' }

    shared_examples 'an invalid range' do |attribute, message|
      it 'returns invalid date' do
        suppress(ArgumentError) do
          expect(range).not_to be_valid
        end
      end

      it 'returns spected error message' do
        suppress(ArgumentError) do
          range.valid?
          expect(range.errors[attribute]).to include(message)
        end
      end
    end

    context 'with valid dates' do
      it 'returns a valid range' do
        expect(range).to be_valid
      end
    end

    context 'with a missing start_date' do
      let(:start_date) { nil }

      it_behaves_like 'an invalid range', :start_date, "can't be blank"
    end

    context 'with a missing end_date' do
      let(:end_date) { nil }

      it_behaves_like 'an invalid range', :end_date, "can't be blank"
    end

    context 'with an invalid start_date' do
      let(:start_date) { 'invalid' }

      it_behaves_like 'an invalid range', :base, 'start_date and end_date must be valid dates'
    end

    context 'with an invalid end_date' do
      let(:end_date) { 'invalid' }

      it_behaves_like 'an invalid range', :base, 'start_date and end_date must be valid dates'
    end

    context 'when end date is before that start date' do
      let(:start_date) { '2025-09-28' }

      it_behaves_like 'an invalid range', :end_date, 'must be after or equal to start_date'
    end
  end
end
