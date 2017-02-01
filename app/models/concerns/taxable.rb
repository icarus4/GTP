module Taxable
  extend ActiveSupport::Concern

  included do
    before_save :calculate_totals, if: :tax_treatment_changed?
    enum tax_treatment: { exclusive: 0, inclusive: 1 }, _prefix: :tax
  end

  # tax_inclusive 的 total tax 公式推導
  # total_without_tax * (100 + tax_rate) / 100 = total
  # total_without_tax * (100 + tax_rate) / 100 = total_without_tax + tax
  # total_without_tax * (100 + tax_rate) / 100 - total_without_tax = tax
  # total_without_tax * ((100 + tax_rate) / 100 - 1) = tax
  # (total - tax) * ((100 + tax_rate) / 100 - 1) = tax
  # total * ((100 + tax_rate) / 100 - 1) - tax * ((100 + tax_rate) / 100 - 1) = tax
  # total * ((100 + tax_rate) / 100 - 1) = tax + tax * ((100 + tax_rate) / 100 - 1)
  # total * ((100 + tax_rate) / 100 - 1) = tax * (1 + ((100 + tax_rate) / 100 - 1))
  # total * ((100 + tax_rate) / 100 - 1) / (1 + ((100 + tax_rate) / 100 - 1)) = tax
  # total / (1 / ((100 + tax_rate) / 100 - 1) + 1) = tax
  def calculate_total_tax
    self.total_tax = if tax_exclusive?
                       line_items.reduce(0) { |total_tax, line_item| total_tax + line_item.total * line_item.tax_rate / 100 }.round(2)
                     else
                       line_items.reduce(0) { |total_tax, line_item| total_tax + line_item.total / (1 / ((100 + line_item.tax_rate) / 100 - 1) + 1) }.round(2)
                     end
  end

  def calculate_totals
    calcualte_subtotal
    calcualte_total_units
    calculate_total_tax
    calculate_total_amount
  end

  def calculate_totals!
    calculate_totals
    save!
  end

  def calcualte_subtotal
    self.subtotal = line_items.sum(:total)
  end

  def calcualte_total_units
    self.total_units = line_items.sum(:quantity)
  end

  def calculate_total_amount
    self.total_amount = tax_exclusive? ? subtotal + total_tax : subtotal
  end
end
