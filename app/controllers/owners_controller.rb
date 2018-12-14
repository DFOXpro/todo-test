class OwnersController < ApplicationController
	def create_owner
		@owner = Owner.new user_tag: params[:user_tag]
		if(
			@owner.save() ||
			@owner.errors.as_json[:user_tag] == ["has already been taken"]
		)
			render(
				status: 200,
				json: {
					user_tag: @owner.user_tag
				}
			) && return
		else
			puts @owner.errors.as_json
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
