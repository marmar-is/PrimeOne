class AddPolicyPdfToPolicy < ActiveRecord::Migration
  def change
    add_column :policies, :policy_pdf, :string
  end
end
