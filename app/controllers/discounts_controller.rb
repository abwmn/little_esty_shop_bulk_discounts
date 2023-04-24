class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new
  end

  def create
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
    if @discount.update(discount_params)
      flash[:success] = "Discount updated successfully."
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = @discount.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    flash[:success] = "Discount deleted successfully."
    redirect_to merchant_discounts_path(params[:merchant_id])
  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :quantity)
  end
end
