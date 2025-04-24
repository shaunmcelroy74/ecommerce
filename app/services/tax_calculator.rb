# app/services/tax_calculator.rb
class TaxCalculator
  # PST, GST, HST rates by province/territory code
  PROVINCE_TAXES = {
    "AB" => { gst: 0.05, pst: 0.00, hst: 0.00 },  # Alberta
    "BC" => { gst: 0.05, pst: 0.07, hst: 0.00 },  # British Columbia
    "MB" => { gst: 0.05, pst: 0.07, hst: 0.00 },  # Manitoba
    "NB" => { gst: 0.00, pst: 0.00, hst: 0.15 },  # New Brunswick
    "NL" => { gst: 0.00, pst: 0.00, hst: 0.15 },  # Newfoundland & Labrador
    "NS" => { gst: 0.00, pst: 0.00, hst: 0.15 },  # Nova Scotia
    "NT" => { gst: 0.05, pst: 0.00, hst: 0.00 },  # Northwest Territories
    "NU" => { gst: 0.05, pst: 0.00, hst: 0.00 },  # Nunavut
    "ON" => { gst: 0.00, pst: 0.00, hst: 0.13 },  # Ontario
    "PE" => { gst: 0.00, pst: 0.00, hst: 0.15 },  # Prince Edward Island
    "QC" => { gst: 0.05, pst: 0.09975, hst: 0.00 }, # Québec (GST + QST)
    "SK" => { gst: 0.05, pst: 0.06, hst: 0.00 },  # Saskatchewan
    "YT" => { gst: 0.05, pst: 0.00, hst: 0.00 }   # Yukon
  }.freeze

  def initialize(subtotal_cents, province_code)
    @subtotal_cents = subtotal_cents
    @rates         = PROVINCE_TAXES.fetch(province_code)
  end

  def gst_cents
    (@subtotal_cents * @rates[:gst]).round
  end

  def pst_cents
    (@subtotal_cents * @rates[:pst]).round
  end

  def hst_cents
    (@subtotal_cents * @rates[:hst]).round
  end

  def rates
    @rates
  end
end
