require 'rails_helper'


RSpec.describe 'Bulk discount update page' do
  before :each do
    @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
    @item1 = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @item2 = @lemarchand.items.create(name: "The Box of Sorrows", description: "The box. You opened it. We came.", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @m_user = @lemarchand.users.create(name: 'Frank', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'frank@labyrinth.com', password: '123456')
    @discount_1 = @lemarchand.discounts.create(required_quantity: 20, percentage: 5)
    @discount_2 = @lemarchand.discounts.create(required_quantity: 30, percentage: 10)

    visit '/login'
    fill_in :email,	with: "#{@m_user.email}"
    fill_in :password,	with: "123456"
    click_button "Log In"
  end

  it "allows clicking a link to a bulk discount edit page" do
    visit "/merchant/discounts"

    within "#discount-#{@discount_2.id}" do
      click_link 'Update Discount'
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}/edit")
  end

  it "allows updating a bulk discount" do
    visit "/merchant/discounts"

    expect(page).to have_content("#{@discount_2.id}")
    expect(page).to have_content("30")
    expect(page).to have_content("10")

    within "#discount-#{@discount_2.id}" do
      click_link 'Update Discount'
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount_2.id}/edit")

    fill_in 'Required quantity', with: "40"
    fill_in 'Percentage', with: "15"

    click_button 'Update Discount'

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("Quantity required for the discount: 40")
    expect(page).to have_content("Discount percentage: 15%")


  end

  it "allows bulk discounts to be deleted" do
    visit "/merchant/discounts"

    within "#discount-#{@discount_2.id}" do
      click_on 'Delete Discount'
    end

    expect(page).to_not have_content("#{@discount_2.id}")
  end


end
