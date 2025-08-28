# frozen_string_literal: true

# Invoice
class Invoice < ApplicationRecord
  validates :invoice_number, presence: true, uniqueness: true
  validates :invoice_date, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  scope :actives, -> { where(active: true, status: "Vigente") }
end
