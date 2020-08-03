require 'rails_helper'


RSpec.describe 'Bulk discount index page' do
  before :each do
    @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
    @item1 = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 999, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @m_user = @lemarchand.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount_1 = @lemarchand.discounts.create(item_name: "#{@item1.name}", required_quantity: 20, percentage: 5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "allows bulk discounts to be viewed from a link on the Merchant dashboard" do
    visit '/merchant'

    click_on 'Bulk Discounts'

    expect(current_path).to eq("/merchant/discounts")


    expect(page).to have_content("#{@item1.name}")
    expect(page).to have_content("Quantity required for the discount: 20")
    expect(page).to have_content("Discount percentage: 5%")

  end
end
