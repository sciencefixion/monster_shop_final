require 'rails_helper'


RSpec.describe 'Bulk discount update page' do
  before :each do
    @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
    @item1 = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @item2 = @lemarchand.items.create(name: "The Box of Sorrows", description: "The box. You opened it. We came.", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @m_user = @lemarchand.users.create(name: 'Frank', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'frank@labyrinth.com', password: '123456')
    @discount_1 = @lemarchand.discounts.create(item_name: "#{@item1.name}", required_quantity: 20, percentage: 5)
    @discount_2 = @lemarchand.discounts.create(item_name: "#{@item1.name}", required_quantity: 30, percentage: 10)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "allows clicking a link to a bulk discount edit page" do
    visit "/merchant/discounts"

    within "#discount-#{@discount_2.id}" do
      click_link 'Update Discount'
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}/edit")
  end

  it "allows updating a bulk discount" do
    visit "/merchant/discounts/#{@discount_2.id}/edit"

    expect(page).to have_content("#{@discount_2.item_name}")
    expect(page).to have_content("@discount_2.required_quantity")
    expect(page).to have_content("10")

    fill_in 'Item name', with: "#{@item2.name}"
    fill_in 'Required quantity', with: "40"
    fill_in 'Percentage', with: "15"

    click_button 'Update Discount'

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("#{@item2.name}")
    expect(page).to have_content("Quantity required for the discount: 40")
    expect(page).to have_content("Discount percentage: 15%")


  end

end
