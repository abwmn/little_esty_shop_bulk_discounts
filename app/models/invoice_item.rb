class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end


  def discounted_revenue
    discount = applicable_discount
    if discount
      discount_percentage = discount.percent.to_f / 100.0
      discounted_price = unit_price * (1 - discount_percentage)
      quantity * discounted_price
    else
      quantity * unit_price
    end
  end

  def applicable_discount
    item.merchant.discounts
        .where('quantity <= ?', quantity)
        .order(percent: :desc)
        .first
  end
end
