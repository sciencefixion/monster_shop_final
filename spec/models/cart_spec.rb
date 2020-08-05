require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 33 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })

      @lemarchand = Merchant.create(name: "LeMarchand Boxes", address: '1717 Rue de L\'Académie Royale', city: 'Paris', state: 'TX', zip: 75460)
      @lament = @lemarchand.items.create(name: "Lament Configuration", description: "We have such sights to show you!", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )
      @box = @lemarchand.items.create(name: "The Box of Sorrows", description: "The box. You opened it. We came.", price: 1000, image: "https://vignette.wikia.nocookie.net/cenobite/images/f/fa/Lament_Configuration.jpg", inventory: 999 )

      @discount_1 = @lemarchand.discounts.create(required_quantity: 2, percentage: 25)
      @discount_2 = @lemarchand.discounts.create(required_quantity: 4, percentage: 50)
      @discount_3 = @brian.discounts.create(required_quantity: 2, percentage: 50)

      # @m_user = @lemarchand.users.create(name: 'Frank', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'frank@labyrinth.com', password: '123456')
      # @user = User.create(name: 'Kirsty', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'kirsty@labyrinth.com', password: '123456')

      @cart2 = Cart.new({
        @lament.id.to_s => 1,
        @hippo.id.to_s => 2,
        @box.id.to_s => 4
        })

      # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.check_for_discount()' do
      expect(@cart2.check_for_discount(@box.id)).to eq([@discount_2])
    end

    it '.item_discount_percentage()' do
      expect(@cart2.item_discount_percentage(@box.id)).to eq(0.5)
    end

    
  end
end
