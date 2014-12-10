class PaymentsController < ApplicationController
  def index
    @payments = Payment.all
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.pay!
      redirect_to root_path, notice: "Thank you for subscribing!"
    else
      render :new
    end
  end

  private
    def payment_params
      params.require(:payment).permit!
    end
end
