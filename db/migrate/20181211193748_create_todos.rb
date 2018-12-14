class CreateTodos < ActiveRecord::Migration[5.2]
	def change
		create_table :todos do |t|
			t.belongs_to :owner
			t.string :data
			t.integer :status_percentage
			t.boolean :status
			t.timestamps :null => false
		end
	end
end
