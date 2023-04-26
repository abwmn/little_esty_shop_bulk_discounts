class Admin::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :edit, :update]
  def index
    @merchants = Merchant.all
    # @enabled_merchants = Merchant.enabled
    # @disabled_merchants = Merchant.disabled
    # speed up loading by filtering a single Merchant query
    # @enabled_merchants = @merchants.select { |m| m.status == 'enabled'}
    # @disabled_merchants = @merchants.select { |m| m.status == 'disabled'}
    # speed up even more filtering @merchants just once
    @enabled_merchants, @disabled_merchants = 
      @merchants.partition do |merchant| 
        merchant.status == 'enabled' 
      end
  end

  def show
  end

  def create
    Merchant.create!(name: params[:name],
                     id: find_new_id)
    flash.notice = 'Merchant Has Been Created!'
    redirect_to admin_merchants_path
  end

  def edit
  end

  def update
    if @merchant.update(merchant_params)
      flash.notice = "Merchant Has Been Updated!"
      redirect_to admin_merchant_path(@merchant)
    else
      flash.notice = "All fields must be completed, get your act together."
      redirect_to edit_admin_merchant_path(@merchant)
    end
  end

  private
  def set_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end

  def find_new_id
    Merchant.last.id + 1
  end
end
