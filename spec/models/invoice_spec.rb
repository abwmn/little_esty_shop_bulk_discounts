require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 11, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_5.id, quantity: 12, unit_price: 6, status: 1)
      @discount1 = @merchant1.discounts.create!(quantity: 5, percent: 5)
      @discount2 = @merchant1.discounts.create!(quantity:10, percent: 10)
    end
    
    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(282)
    end

    it "total_discounted_revenue" do
      # Update the initial quantity of items to avoid discounts
      @ii_1.update(quantity: 4)
      @ii_2.update(quantity: 4)
      @ii_1.reload
      @ii_2.reload
    
      # No discounts applied (discounts can only apply to m1's items, ii_1, ii_2, and ii_11)
      # 4 * 10 + 4 * 10 + 1 * 10 + 12 * 6 = 162
      expect(@invoice_1.total_discounted_revenue).to eq(162)
      expect(@invoice_1.total_discounted_revenue).to eq(@invoice_1.total_revenue)
    
      # Apply a 5% discount to @ii_1 
      @ii_1.update(quantity: 5)
      @ii_1.reload
      @invoice_1.reload
      # # 5 * 10 * 0.95 + 4 * 10 + 1 * 10 + 12 * 6 = 169.5
      expect(@invoice_1.total_revenue).to eq(172)
      expect(@invoice_1.total_discounted_revenue).to eq(169.5)
    
      # # Apply a 10% discount to @ii_2 
      @ii_2.update(quantity: 10)
      @ii_2.reload 
      @invoice_1.reload
      # 5 * 10 * 0.95 + 10 * 10 * 0.90 + 1 * 10 + 12 * 6 = 219.5
      expect(@invoice_1.total_discounted_revenue).to eq(219.5)
    
      # Apply a 10% discount to both @ii_1 and @ii_2 
      @ii_1.update(quantity: 10)
      @ii_1.reload 
      @invoice_1.reload
      # 10 * 10 * 0.90 + 10 * 10 * 0.90 + 1 * 10 + 12 * 6 = 262
      expect(@invoice_1.total_discounted_revenue).to eq(262)
    end

    it "merchant_total_revenue" do
      expect(@invoice_1.merchant_total_revenue(@merchant1)).to eq(210)
      expect(@invoice_1.merchant_discounted_revenue(@merchant1)).to eq(194.5)
    end
  end
end
