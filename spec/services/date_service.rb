require 'rails_helper'

RSpec.describe NagerDateService, type: :service do
  describe '.next_3_public_holidays' do
    it 'returns the next 3 upcoming holidays' do
      holidays = NagerDateService.next_holidays

      expect(holidays).to be_an(Array)
      expect(holidays.count).to eq(3)

      holidays.each do |holiday|
        expect(holiday).to have_key('name')
        expect(holiday).to have_key('date')
      end
    end
  end
end
