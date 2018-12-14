window.OwnersView = class
	_this = null
	_oc = null

	constructor: ->
		console.log 'OwnersView.constructor'
		@submitEL = document.querySelector '#user_tag_button'
		@textEL = document.querySelector '#user_tag_text'
		_this = this
		_oc = new OwnersController _this

		# user_tag actions events
		@textEL.onchange = _oc.validateOwner
		@submitEL.addEventListener 'click', _oc.changeOwner, false
