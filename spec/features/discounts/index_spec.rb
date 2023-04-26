require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  before :each do
    @merchant = Merchant.create!(name: 'Test Merchant')
    @discount1 = @merchant.discounts.create!(percent: 10, quantity: 5)
    @discount2 = @merchant.discounts.create!(percent: 20, quantity: 10)
    @discount3 = @merchant.discounts.create!(percent: 30, quantity: 15)
  end

  it 'displays all my discounts with percentage and quantity thresholds' do
    visit merchant_dashboard_index_path(@merchant)

    click_link 'Discounts'

    expect(current_path).to eq(merchant_discounts_path(@merchant))

    within("#discounts") do
      expect(page).to have_content("Percentage Discount")
      expect(page).to have_content("Quantity Threshold")
      [@discount1, @discount2, @discount3].each do |discount|
        expect(page).to have_content("#{discount.percent}%")
        expect(page).to have_content(discount.quantity)
        expect(page).to have_link('Show', href: merchant_discount_path(@merchant, discount))
      end
    end
  end


  it 'displays next 3 public holidays' do
    visit merchant_discounts_path(@merchant)

    expect(page).to have_content("Upcoming Holidays")

    within('.holidays') do
      expect('Memorial Day - 2023-05-29').to appear_before('Juneteenth - 2023-06-19')
      expect('Juneteenth - 2023-06-19').to appear_before('Independence Day - 2023-07-04')
      expect(page).not_to have_content('Labour Day - 2023-09-04')
    end
  end
end
