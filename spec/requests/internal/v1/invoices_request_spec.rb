# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Internal::V1::Invoices', type: :request do
  let(:token) do
    'eyJhbGciOiJIUzI1NiJ9.InRlc3Qi.JTwhNTBuEYVpnZ58ZynjS77g98R7DKn939Sw5kHt8z8'
  end
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('INTERNAL_SECRET').and_return('test')
    allow(ENV).to receive(:[]).with('INTERNAL_TOKEN').and_return('test')
  end

  describe 'GET /internal/v1/invoices' do
    let(:path) { '/internal/v1/invoices' }
    let(:params) do
      {
        start_date: start_date,
        end_date: end_date
      }
    end

    let(:start_date) { '2025-08-01' }
    let(:end_date) { '2025-08-02' }

    let(:expected_response) do
      [
        {
          'attributes' => {
            'active' => true,
            'invoice_date' => '2025-08-05T00:00:00.000-06:00',
            'invoice_number' => 'FAC-1012',
            'status' => 'Vigente',
            'total' => '100.0'
          },
          'id' => 8493,
          'type' => 'invoices'
        }
      ]
    end

    before do
      allow(ENV).to receive(:fetch).and_call_original
      Pagy::DEFAULT[:limit] = 2
      create(:invoice, invoice_date: '2025-08-01')
      create(:invoice, invoice_date: '2025-08-02')
      create(:invoice, invoice_date: '2025-08-05', id: 8493, invoice_number: 'FAC-1012')

      get path, params:, headers: headers
    end

    context 'when send a valid token' do
      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns cached invoices as JSON' do
        json = JSON.parse(response.body)
        expect(json['data'].count).to eq(2)
      end

      context 'with a valid structure' do
        let(:start_date) { '2025-08-05' }
        let(:end_date) { '2025-08-05' }

        it 'returns expected structure' do
          json = JSON.parse(response.body)
          expect(json['data']).to eq(expected_response)
        end
      end
    end

    context 'when send a valid token with pagination' do
      let(:end_date) { '2025-08-05' }

      let(:params) do
        {
          start_date: start_date,
          end_date: end_date,
          page: 2
        }
      end

      it 'returns valid pagination records' do
        json = JSON.parse(response.body)
        expect(json['data'].count).to eq(1)
      end
    end

    context 'when end an invalid params' do
      let(:end_date) { 'invalid' }

      it 'returns 400 status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when end an invalid token' do
      let(:token) { 'invalid' }

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
