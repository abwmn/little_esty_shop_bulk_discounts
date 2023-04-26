Transaction.destroy_all
InvoiceItem.destroy_all
Invoice.destroy_all
Customer.destroy_all
Discount.destroy_all
Item.destroy_all
Merchant.destroy_all

# Create Merchants
merchant1 = Merchant.create!(name: 'Hair Care')
merchant2 = Merchant.create!(name: 'Jewelry')

# Create Items for Merchant 1
item1 = merchant1.items.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10.0, status: 1)
item2 = merchant1.items.create!(name: 'Conditioner', description: 'This softens your hair', unit_price: 8.0, status: 0)

# Create Items for Merchant 2
item3 = merchant2.items.create!(name: 'Bracelet', description: 'Wrist bling', unit_price: 200.0, status: 1)
item4 = merchant2.items.create!(name: 'Necklace', description: 'Neck bling', unit_price: 150.0, status: 1)

# Create Customer
customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

# Create Invoice for Customer 1
invoice1 = customer1.invoices.create!(status: 2, created_at: "2023-04-26 14:54:09")

# Create Invoice Items
invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 5, unit_price: 10.0, status: 2)
invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 3, unit_price: 8.0, status: 1)
invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 200.0, status: 0)

# Create Transaction for Invoice 1
transaction1 = invoice1.transactions.create!(credit_card_number: '1234567812345678', credit_card_expiration_date: '', result: 1)

# Create Discounts for Merchant 1
discount1 = merchant1.discounts.create!(quantity: 5, percent: 5)
discount2 = merchant1.discounts.create!(quantity: 10, percent: 10)

# Create Discounts for Merchant 2
discount3 = merchant2.discounts.create!(quantity: 3, percent: 15)
