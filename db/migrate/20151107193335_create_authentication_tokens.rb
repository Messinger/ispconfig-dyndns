class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :token
      t.references :account, polymorphic: true, index: true

      t.timestamps
    end
    add_index :authentication_tokens, :token, unique: true
  end
end
