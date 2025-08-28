# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reports::Sells::TopDailyReportMailer, type: :mailer do
  describe '#send_report' do
    let(:summary) do
      {
        Date.today => 100.0,
        Date.yesterday => 50.0
      }
    end

    let(:mail) { described_class.send_report(summary: summary) }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV)
        .to receive(:fetch)
        .with('FINANCE_USERS_EMAILS', any_args)
        .and_return('zepeda@gmail.com')
    end

    it 'renders the subject' do
      expect(mail.subject).to eq('Reporte de ventas diarias')
    end

    it 'sends to the correct BCC recipients' do
      expect(mail.bcc).to contain_exactly('zepeda@gmail.com')
    end

    it 'assigns @summary' do
      expect(mail.body.encoded).to include('100.0', '50.0')
    end

    it 'renders the headers' do
      expect(mail.from).to eq(['contalink@test.com'])
    end
  end
end
