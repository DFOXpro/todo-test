class CreateOwners < ActiveRecord::Migration[5.2]
  def change
		create_table :owners do |t|
			# public number to identify it self
			t.string :user_tag, limit: Owner::USER_TAG_SIZE, null: false
			# key to trivial cypher
			t.string :seed, limit: Owner::SEED_SIZE, null: false

			# t.string :password

			t.timestamps :null => false
    end
  end
end
