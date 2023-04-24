require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Delete' do
  before :each do
    @merchant = Merchant.create!(name: 'Test Merchant')
    @discount1 = @merchant.discounts.create!(percent: 10, quantity: 10)
    @discount2 = @merchant.discounts.create!(percent: 15, quantity: 20)
  end

  it 'allows a merchant to delete a discount from the bulk discounts index page' do
    visit merchant_discounts_path(@merchant)

    expect(page).to have_content(@discount1.percent)
    expect(page).to have_content(@discount1.quantity)
    expect(page).to have_content(@discount2.percent)
    expect(page).to have_content(@discount2.quantity)

    within("#discount-#{@discount1.id}") do
      click_link 'Delete'
    end

    expect(current_path).to eq(merchant_discounts_path(@merchant))

    expect(page).to have_no_css("#discount-#{@discount1.id}")
    expect(page).to_not have_content(@discount1.percent)
    expect(page).to_not have_content(@discount1.quantity)

    expect(page).to have_content(@discount2.percent)
    expect(page).to have_content(@discount2.quantity)
  end
end
