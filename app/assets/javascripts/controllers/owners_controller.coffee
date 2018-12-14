window.OwnersController = class
	_this = null

	constructor: (@ov)->
		console.log 'OwnersController.constructor'
		_this = this
		Owner.getOrRequestUserTag()
		.then (user_tag) ->
			console.log 'asd', _this.ov.textEL, user_tag
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
		_this.ov.submitEL.disabled = true
		Owner.changeUserTag _this.ov.textEL.value
		.then (r) ->
			_this.ov.submitEL.disabled = false
			if r.status
				View.popMessage '#user_tag_success_msg'
			else
				View.popMessage '#user_tag_error_msg', r.data.errors
