require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Create' do
  before :each do
    @merchant = Merchant.create!(name: 'Test Merchant')
  end

  it 'allows a merchant to create a new discount with valid data' do
    visit merchant_dashboard_index_path(@merchant)

    click_link 'Discounts'

    within(".discounts") do
      expect(page).not_to have_content("15%")
      expect(page).not_to have_content("10")
    end

    click_link 'Create a New Discount'

    fill_in 'Percentage Discount (%)', with: 15.0
    fill_in 'Quantity Threshold', with: 10

    click_button 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path(@merchant))

    within(".discounts") do
      expect(page).to have_content("15%")
      expect(page).to have_content("10")
    end

    expect(page).to have_content("Discount created successfully.")
  end

  it 'does not allow a merchant to create a discount with blank fields' do
    visit merchant_dashboard_index_path(@merchant)

    click_link 'Discounts'
    click_link 'Create a New Discount'
    click_button 'Create Discount'

    expect(page).to have_content("Percent can't be blank")
    expect(page).to have_content("Quantity can't be blank")
  end

  it 'does not allow a merchant to create a discount with negative values' do
    visit merchant_dashboard_index_path(@merchant)

    click_link 'Discounts'
    click_link 'Create a New Discount'
    fill_in 'Percentage Discount (%)', with: -15.0
    fill_in 'Quantity Threshold', with: -10
    click_button 'Create Discount'

    expect(page).to have_content("Percent must be greater than 0")
    expect(page).to have_content("Quantity must be greater than 0")
  end
end
