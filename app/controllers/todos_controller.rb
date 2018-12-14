class TodosController < ApplicationController
	before_action :find_owner
	before_action :find_todo, only: [:update_todo, :destroy_todo]

	def list_todos
		@todos = Todo.where(owner: @owner).order(:created_at)
		if @todos.size
			render(
				status: 200,
				json: {
					todos: @todos.map {|t| t.public_info}
				}
			) && return
		else
			render(
				status: 404,
				json: {
					message: t('alerts.not_found'),
					errors: @todos.errors.as_json
				}
			) && return
		end
	end

	def create_todo
		_new_todo = todo_create_update_params
		_new_todo[:owner] = @owner
		@todo = Todo.create_todo _new_todo
		if @todo.save
			render(
				status: 200,
				json: {
					todo: @todo.public_info
				}
			) && return
		else
			render(
				status: 400,
				json: {
					message: t('alerts.create_error'),
					errors: @todo.errors.as_json
				}
			) && return
		end
	end

	def update_todo
		if @todo.update todo_create_update_params
			render(
				status: 200,
				json: {
					id: @todo.id,
					update: true
				}
			) && return
		else
			render(
				status: 500,
				json: {
					errors: @todo.errors,
					message: t('alerts.update_error')
				}
			) && return
		end
	end
	def destroy_todo
		unless @todo.destroy
			render(
				status: 500,
				json: {
					errors: @todo.errors,
					message: t('alerts.delete_error')
				}
			) && return
		end

		render(
			status: 200,
			json: {
				delete: true
			}
		) && return
	end

	private
	def todo_create_update_params
		params.require(:todo).permit(
			:data,
			:status,
			:status_percentage,
		)
	end

	def find_owner
		@owner = Owner.find_by user_tag: params[:user_tag] if params[:user_tag].present?
		unless @owner.present?
			render(
				status: 404,
				json: {
					message: t('alerts.not_found'),
					# errors: @owner.errors.as_json
				}
			) && return
		end
	end

	def find_todo
		@todo = Todo.find params[:todo_id]
		unless @todo.present?
			render(
				status: 404,
				json: {
					message: t('alerts.not_found'),
					# errors: @todo.errors.as_json
				}
			) && return
		end
	end
end
