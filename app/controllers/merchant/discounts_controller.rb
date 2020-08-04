class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @discount = Discount.new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
    else
      generate_flash(@discount)
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    # binding.pry
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      generate_flash(@discount)
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:item_name, :required_quantity, :percentage)
  end

end
