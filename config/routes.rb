Rails.application.routes.draw do
	root to: 'application#root', as: :application_root
	scope 'api/v1' do
		# toDoOwners
		scope 'owners', controller: :owners do
			#get '', action: :list_owners
			post '', action: :create_owner
			# post 'create_owner', action: :create_owner
			scope ':owner_id' do
				patch '', action: :update_owner
				# delete '', action: :destroy_owner
			end
		end
		# ToDo
		scope 'todos', controller: :todos do
			get '', action: :list_todos
			post '', action: :create_todo
			# post 'create_owner', action: :create_owner
			scope ':todo_id' do
				patch '', action: :update_todo
				delete '', action: :destroy_todo
			end
		end
	end
	# get '*', to: proc { [404, {}, ['']] }, as: :not_found
end
