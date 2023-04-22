class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "Discount created successfully."
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = @discount.errors.full_messages.join(", ")
      render :new
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new
  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :quantity)
  end
end
