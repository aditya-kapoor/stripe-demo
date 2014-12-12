class Payment < ActiveRecord::Base
  validates :email, :amount, :card_number, :card_code, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  attr_accessor :stripe_card_token, :card_number, :card_code

  def pay!
    if valid?
      customer = Stripe::Customer.create({
        card: stripe_card_token,
        email: email
      })
      Stripe::Charge.create({
        amount: amount,
        currency: 'usd',
        customer: customer.id
      })
      self.stripe_card_token = customer.id
      save!
    end
  rescue Stripe::CardError => e
    Rails.logger.info("Stripe Card Error : #{ e.message }")
    errors.add(:base, 'There was some error with your card. Please try again.')
    false
  rescue Stripe::InvalidRequestError => e
    Rails.logger.info("Stripe Error : #{ e.message }")
    errors.add(:base, 'There was some error. Please try again after some time.')
    false
  end
end
