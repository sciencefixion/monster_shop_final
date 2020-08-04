require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :required_quantity}
    it {should validate_presence_of :percentage}
  end

  before :each do
    @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
    @item1 = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @item2 = @lemarchand.items.create(name: "The Box of Sorrows", description: "The box. You opened it. We came.", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @m_user = @lemarchand.users.create(name: 'Frank', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'frank@labyrinth.com', password: '123456')
    @discount_1 = @lemarchand.discounts.create(required_quantity: 20, percentage: 5)
    @discount_2 = @lemarchand.discounts.create(required_quantity: 30, percentage: 10)

    @user = User.create(name: 'Kirsty', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'kirsty@labyrinth.com', password: '123456')

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "can apply_discount" do
  end
end
