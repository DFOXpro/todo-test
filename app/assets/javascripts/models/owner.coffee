window.Owner = class
	_userTagValidatorRexp = /^[A-Z0-9]{3,8}$/
	user_tag = ''

	_write_user_tag = (r) ->
		user_tag = r.data.user_tag
		localStorage.setItem 'user_tag', user_tag

	_anounce_user_tag = ->
		console.log '_anounce_user_tag'
		window.user_tag_ready = true
		# window.dispatchEvent new CustomEvent 'user_tag_update', user_tag
		window.tc.getTodoListAndUpdate user_tag
		false

	# It's a singleton like class
	# constructor: ()->

	@getUserTag: ->
		console.log 'Owner@getUserTag', user_tag
		return user_tag || localStorage.getItem 'user_tag'

	#return: promise
	@getOrRequestUserTag: ->
		# we can salt the user tag but not now
		user_tag = user_tag || localStorage.getItem 'user_tag'
		console.log 'Owner@getOrRequestUserTag', user_tag
		new Promise (resolve, reject)->
			if user_tag
				console.log 'localStorage', user_tag
				resolve user_tag
				_anounce_user_tag()
			else
				xhr ROUTES.API.api.v1.owners.create
				.then (r)->
					_write_user_tag r
					resolve user_tag
					_anounce_user_tag()
					false
				# .then reject
			false

	@validateUserTag: (user_tag)->
		console.log 'Owner@validateUserTag', user_tag.toUpperCase()
		return false unless user_tag
		_userTagValidatorRexp.test user_tag.toUpperCase()

	@changeUserTag: (newUserTag)->
		# newUserTag = $('#user_tag_text').value()
		newUserTag = newUserTag.toUpperCase()
		return false if newUserTag == Owner.getUserTag
		return false unless Owner.validateUserTag newUserTag
		new Promise (resolve, reject)->
			xhr ROUTES.API.api.v1.owners.create, null, user_tag: newUserTag
			.then (r)->
				_write_user_tag r
				resolve r
				_anounce_user_tag()
				false
