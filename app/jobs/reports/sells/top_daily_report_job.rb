# frozen_string_literal: true

module Reports
  # Reports::Sells
  module Sells
    # Reports::Sells::TopDailyReportJob
    class TopDailyReportJob < ApplicationJob
      queue_as :reports
      sidekiq_options retry: 3, priority: 10

      def perform
        Reports::Sells::TopDailyReportMailer
          .send_report(summary: top_selliing_days_summary)
          .deliver_now
      end

      private

      def top_selliing_days_summary
        Invoice
          .actives
          .group('DATE(invoice_date)')
          .order('SUM(total) DESC')
          .limit(10)
          .sum(:total)
      end
    end
  end
end
