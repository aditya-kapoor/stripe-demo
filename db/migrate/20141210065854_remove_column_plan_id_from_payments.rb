class RemoveColumnPlanIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :plan_id, :integer
  end
end
