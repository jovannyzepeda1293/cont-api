# Pagy configuration
require 'pagy/extras/overflow'
require 'pagy/extras/array'

Pagy::DEFAULT[:limit] = ENV.fetch('PAGINATION_RECORDS', 20).to_i
Pagy::DEFAULT[:overflow] = :empty_page
