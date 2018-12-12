class ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	def root
		@user_tag = 'asd'
	end
end
