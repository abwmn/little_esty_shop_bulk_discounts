require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show' do
  before :each do
    @merchant = Merchant.create!(name: 'Test Merchant')
    @discount = @merchant.discounts.create!(percent: 10, quantity: 5)
  end

  it 'allows a merchant to view the details of a discount on the discount show page' do
    visit merchant_discount_path(@merchant, @discount)

    expect(page).to have_content(@discount.percent)
    expect(page).to have_content(@discount.quantity)
  end
end