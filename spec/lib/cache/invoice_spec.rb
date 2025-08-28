# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cache::Invoice do
  describe '.get_range' do
    subject { described_class.get_range(start_date:, end_date:) }
    let(:start_date) { '2025-08-27' }
    let(:end_date) { '2025-08-27' }

    before do
      allow(described_class).to receive(:fetch_range_from_db).and_call_original
      create(
        :invoice,
        invoice_date: '2025-08-27',
        id: 1516,
        invoice_number: 'FAC-1002',
        total: 100
      )
    end

    let(:valid_response) do
      [
        {
          'active' => true,
          'id' => 1516,
          'invoice_date' => '2025-08-27T00:00:00.000-06:00',
          'invoice_number' => 'FAC-1002',
          'status' => 'Vigente',
          'total' => '100.0'
        }
      ]
    end

    around do |example|
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
      Rails.cache.clear
      example.run
      Rails.cache.clear
      Rails.cache = ActiveSupport::Cache::NullStore.new
    end

    context 'when send a valid date' do
      context 'when data is not loaded in cache' do
        it 'loads records from db' do
          subject
          expect(described_class).to have_received(:fetch_range_from_db).once
        end

        it 'returns expected records' do
          expect(subject).to match_array(valid_response)
        end
      end

      context 'when data is loaded in cache' do
        let(:second_call) { described_class.get_range(start_date:, end_date:) }
        before { subject }

        it 'calls the database only the first time and uses cache afterwards' do
          second_call
          expect(described_class).to have_received(:fetch_range_from_db).once
        end

        it 'returns expected records' do
          expect(second_call).to match_array(valid_response)
        end
      end
    end

    context 'when send an invalid date' do
      let(:end_date) { '2025-8-26' }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
