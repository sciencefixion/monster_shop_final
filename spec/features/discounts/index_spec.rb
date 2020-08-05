require 'rails_helper'


RSpec.describe 'Bulk discount index page' do
  before :each do
    @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
    @item1 = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
    @m_user = @lemarchand.users.create(name: 'Frank', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'frank@labyrinth.com', password: '123456')
    @discount_1 = @lemarchand.discounts.create(required_quantity: 20, percentage: 5)

    visit '/login'
    fill_in :email,	with: "#{@m_user.email}"
    fill_in :password,	with: "123456"
    click_button "Log In"
  end

  it "allows bulk discounts to be viewed from a link on the Merchant dashboard" do
    visit '/merchant'

    click_on 'Bulk Discounts'

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("Quantity required for the discount: 20")
    expect(page).to have_content("Discount percentage: 5%")

  end

  it "allows bulk discount creation" do
    visit '/merchant/discounts'

    click_on 'Create New Bulk Discount'

    expect(current_path).to eq("/merchant/discounts/new")

    fill_in 'Required quantity', with: "30"
    fill_in 'Percentage', with: "10"

    click_button 'Create Discount'


    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("#{@discount_1.id}")
    expect(page).to have_content("Quantity required for the discount: 30")
    expect(page).to have_content("Discount percentage: 10%")


  end
end
