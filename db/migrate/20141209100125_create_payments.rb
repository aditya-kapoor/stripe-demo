class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :email
      t.string :plan_id
      t.string :stripe_card_token

      t.timestamps
    end
  end
end
