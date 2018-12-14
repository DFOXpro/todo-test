Rails.application.routes.draw do
	root to: 'application#root', as: :application_root
	scope 'api/v1' do
		# toDoOwners
		scope 'owners', controller: :owners do
			#get '', action: :list_owners
			post '', action: :create_owner, as: :owners_create
			# scope ':owner_id' do
			# 	patch '', action: :update_owner, as: :owners_
			# 	delete '', action: :destroy_owner
			# end
		end
		# ToDo
		scope 'todos', controller: :todos do
			get '', action: :list_todos, as: :todos_list
			post '', action: :create_todo, as: :todos_create
			scope ':todo_id' do
				patch '', action: :update_todo, as: :todos_update
				delete '', action: :destroy_todo, as: :todos_destroy
			end
		end
	end
	# get '*', to: proc { [404, {}, ['']] }, as: :not_found
end
