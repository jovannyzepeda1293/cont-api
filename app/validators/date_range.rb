# frozen_string_literal: true

# DateRange
class DateRange
  include ActiveModel::Model

  attr_accessor :start_date, :end_date

  validates :start_date, :end_date, presence: true
  validate :valid_dates
  validate :end_after_start

  private

  def valid_dates
    Time.parse(start_date.to_s)
    Time.parse(end_date.to_s)
  rescue ArgumentError
    errors.add(:base, 'start_date and end_date must be valid dates')
  end

  def end_after_start
    return if start_date.blank? || end_date.blank?

    return unless Time.parse(end_date).at_end_of_day < Time.parse(start_date).at_beginning_of_day

    errors.add(:end_date, 'must be after or equal to start_date')
  end
end
