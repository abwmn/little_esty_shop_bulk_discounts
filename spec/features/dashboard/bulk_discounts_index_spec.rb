# spec/features/dashboard/bulk_discounts_index_spec.rb

require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  before :each do
    # Create a test merchant
    @merchant = Merchant.create!(name: 'Test Merchant')

    # Create test discounts for the merchant
    @discount1 = @merchant.discounts.create!(percent: 0.1, quantity: 5)
    @discount2 = @merchant.discounts.create!(percent: 0.2, quantity: 10)
    @discount3 = @merchant.discounts.create!(percent: 0.3, quantity: 15)
  end

  it 'displays all my discounts with percentage and quantity thresholds' do
    # Visit the merchant dashboard
    visit merchant_dashboard_index_path(@merchant)

    # Click the link to view all discounts
    click_link 'Discounts'

    # Verify that we are on the bulk discounts index page
    expect(current_path).to eq(merchant_discounts_path(@merchant))
    save_and_open_page

    # Verify that all discounts are displayed with their attributes
    within(".discounts") do
      expect(page).to have_content("Percentage Discount")
      expect(page).to have_content("Quantity Threshold")
      [@discount1, @discount2, @discount3].each do |discount|
        expect(page).to have_content("#{(discount.percent*100).to_i}%")
        expect(page).to have_content(discount.quantity)
        expect(page).to have_link('Show', href: merchant_discount_path(@merchant, discount))
      end
    end
  end
end
