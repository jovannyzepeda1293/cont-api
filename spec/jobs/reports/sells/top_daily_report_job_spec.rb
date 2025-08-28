# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reports::Sells::TopDailyReportJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    before do
      create(:invoice, :expired, invoice_date: '2/08/2025')
      create(:invoice, :inactive, invoice_date: '2/08/2025')
      create(:invoice, invoice_date: '1/08/2025', total: 80)
      create(:invoice, invoice_date: '2/08/2025', total: 90)
      create(:invoice, invoice_date: '3/08/2025', total: 100)
      create(:invoice, invoice_date: '4/08/2025', total: 110)
      create(:invoice, invoice_date: '5/08/2025', total: 120)
      create(:invoice, invoice_date: '6/08/2025', total: 130)
      create(:invoice, invoice_date: '7/08/2025', total: 140)
      create(:invoice, invoice_date: '8/08/2025', total: 150)
      create(:invoice, invoice_date: '9/08/2025', total: 160)
      create(:invoice, invoice_date: '10/08/2025', total: 170)
      create(:invoice, invoice_date: '11/08/2025', total: 180)
      create(:invoice, invoice_date: '9/08/2025', total: 190)
      create(:invoice, invoice_date: '5/08/2025', total: 200)

      allow(Reports::Sells::TopDailyReportMailer)
        .to receive_message_chain(:send_report, :deliver_now)
        .and_return(true)
    end

    let(:values) do
      {
        'Sat, 09 Aug 2025' => 350,
        'Tue, 05 Aug 2025' => 320,
        'Mon, 11 Aug 2025' => 180,
        'Sun, 10 Aug 2025' => 170,
        'Fri, 08 Aug 2025' => 150,
        'Thu, 07 Aug 2025' => 140,
        'Wed, 06 Aug 2025' => 130,
        'Mon, 04 Aug 2025' => 110,
        'Sun, 03 Aug 2025' => 100,
        'Sat, 02 Aug 2025' => 90
      }
    end

    it 'queues the job in the reports queue' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue('reports')
    end

    it 'calls the mailer with top selling days summary' do
      described_class.perform_now
      expect(Reports::Sells::TopDailyReportMailer)
        .to have_received(:send_report)
    end

    it 'returns expected values' do
      captured_args = nil

      allow(Reports::Sells::TopDailyReportMailer)
        .to receive(:send_report) { |args|
              captured_args = args
              double(deliver_now: true)
            }

      described_class.perform_now

      summary = captured_args[:summary]
      values.each do |date, total|
        expect(summary[Date.parse(date)]).to eq(total)
      end
    end
  end
end
