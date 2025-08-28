# frozen_string_literal: true

json.data @paginated do |invoice|
  json.id invoice['id']
  json.type 'invoices'
  json.attributes do
    json.invoice_number invoice['invoice_number']
    json.total invoice['total']
    json.invoice_date invoice['invoice_date']
    json.status invoice['status']
    json.active invoice['active']
  end
end

json.meta do
  json.page @pagy.page
  json.count @pagy.count
  json.pages @pagy.pages
end
