# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    sequence(:invoice_number) { |n| "FAC-#{1000 + n}" }
    total { 100.0 }
    invoice_date { Date.today }
    status { 'Vigente' }
    active { true }

    trait :expired do
      status { 'Expired' }
    end

    trait :inactive do
      active { false }
    end
  end
end
