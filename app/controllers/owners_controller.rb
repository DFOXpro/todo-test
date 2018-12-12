class OwnersController < ApplicationController
	def create_owner
		@owner = Owner.new
		if @owner.save
			render(
				status: 200,
				json: {
					user_tag: @owner.user_tag
				}
			) && return
		else
			render(
				status: 400,
				json: {
					message: t('alerts.error_saving'),
					errors:	@owner.errors.as_json
				}
			) && return
		end
	end
end
