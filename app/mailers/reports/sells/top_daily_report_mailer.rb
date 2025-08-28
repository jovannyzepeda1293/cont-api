# frozen_string_literal: true

module Reports
  # Reports::Sells
  module Sells
    # Reports::Sells::TopDailyReportMailer
    class TopDailyReportMailer < ApplicationMailer
      def send_report(summary:)
        @summary = summary

        finance_emails =
          ENV.fetch('FINANCE_USERS_EMAILS', 'zepeda.roque32@gmail.com').split(',').map(&:strip)

        mail(
          bcc: finance_emails,
          subject: 'Reporte de ventas diarias'
        )
      end
    end
  end
end
