# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::JwtService do
  let(:token) { 'eyJhbGciOiJIUzI1NiJ9.InRlc3Qi.JTwhNTBuEYVpnZ58ZynjS77g98R7DKn939Sw5kHt8z8' }

  describe '.encode' do
    subject { described_class.encode(payload: 'test', secret_key: 'test') }

    it 'encodes key' do
      expect(subject).to eq(token)
    end
  end

  describe '.decode' do
    subject { described_class.decode(token:, secret_key: 'test') }

    it 'decodes token' do
      expect(subject).to eq('test')
    end

    context 'with an invalid token' do
      let(:token) { 'invalid' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
