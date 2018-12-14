window.OwnersController = class
	_this = null

	constructor: (@ov)->
		console.log 'OwnersController.constructor'
		_this = this
		Owner.getOrRequestUserTag()
		.then (user_tag) ->
			_this.ov.textEL.value = user_tag
		# , (r) ->
		# 	console.log 'getOwnerError', r
		# 	View.popMessage '#user_tag_error_msg', r.errors

	validateOwner: ->
		console.log 'OwnersController.validateOwner', _this
		View.inputStatus(
			_this.ov.textEL,
			Owner.validateUserTag _this.ov.textEL.value
		)

	changeOwner: ->
		console.log 'OwnersController.changeOwner', _this
		Owner.changeUserTag _this.ov.textEL.value
		.then (r) ->
			if r.data.user_tag
				_this.ov.textEL.value = r.data.user_tag
				View.popMessage '#user_tag_success_msg'
			else
				View.popMessage '#user_tag_error_msg', r.data.errors
