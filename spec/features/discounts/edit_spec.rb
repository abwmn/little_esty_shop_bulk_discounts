require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit' do
  before :each do
    @merchant = Merchant.create!(name: 'Test Merchant')
    @discount = @merchant.discounts.create!(percent: 10, quantity: 5)
  end

  it 'allows a merchant to edit a discount from the discount show page' do
    visit merchant_discount_path(@merchant, @discount)

    click_link 'Edit Discount'

    expect(current_path).to eq(edit_merchant_discount_path(@merchant, @discount))

    expect(find_field('Percentage Discount (%)').value).to eq(@discount.percent.to_s)
    expect(find_field('Quantity Threshold').value).to eq(@discount.quantity.to_s)

    fill_in 'Percentage Discount (%)', with: 15
    fill_in 'Quantity Threshold', with: 8

    click_button 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
    expect(page).to have_content("Percentage Discount: 15%")
    expect(page).to have_content("Quantity Threshold: 8")

    click_link 'Edit Discount'

    expect(current_path).to eq(edit_merchant_discount_path(@merchant, @discount))

    fill_in 'Percentage Discount (%)', with: -15
    fill_in 'Quantity Threshold', with: -8
    click_button 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
    expect(page).to have_content('Percent must be greater than 0')
    expect(page).to have_content('Quantity must be greater than 0')
    expect(page).not_to have_link('Edit Discount')

    fill_in 'Percentage Discount (%)', with: 20
    fill_in 'Quantity Threshold', with: 10
    click_button 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
    expect(page).to have_link('Edit Discount')
  end
end
