class Payment < ActiveRecord::Base
  validates :email, :amount, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  attr_accessor :stripe_card_token

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
  rescue Stripe::InvalidRequestError => e
    Rails.logger.info("Stripe Error : #{ e.message }")
    errors.add(:base, 'There was some error. Please try again after some time.')
    false
  end
end
