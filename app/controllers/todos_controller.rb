class TodosController < ApplicationController
	before_action :find_owner
  def list_todos
		@todos = Todo.where owner: @owner
		if @todos.size
			render(
				status: 200,
				json: {
					todos: @todos.map {|t| t.public_info}
				}
			) && return
		else
			render(
				status: 400,
				json: {
					message: t('alerts.error_saving'),
					errors:	@todos.errors.as_json
				}
			) && return
		end
  end

	private
	def find_owner
		@owner = Owner.find_by user_tag: params[:user_tag]
		unless @owner.present
			render(
				status: 404,
				json: {
					message: t('owners.not_found'),
					# errors:	@owner.errors.as_json
				}
			) && return
		end
	end
end
