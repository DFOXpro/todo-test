#= require_tree .

# models/owner.coffee
class Owner
	_userTagValidatorRexp = /^[A-Z0-9]{3,8}$/
	user_tag = ''

	_anounce_user_tag = ->
		new CustomEvent('user_tag_update', { user_tag: user_tag });

	# It's a singleton like class
	# constructor: ()->

	@getOrRequestUserTag: ->
		# we can salt the user tag but not now
		user_tag = user_tag || localStorage.getItem 'user_tag'
		console.log 'Owner@getOrRequestUserTag', !!user_tag
		new Promise (resolve, reject)->
			if user_tag
				_anounce_user_tag()
				resolve user_tag
			else
				xhr ROUTES.API.api.v1.owners.create
				.then (r)->
					console.log 'XHR success', r, ROUTES.API.api.v1.owners.create
					user_tag = r.data.user_tag
					_anounce_user_tag()
					localStorage.setItem 'user_tag', user_tag
					resolve user_tag
					false
				# .then reject
			false

	@validateUserTag: (user_tag)->
		console.log 'Owner@validateUserTag', user_tag.toUpperCase()
		return false unless user_tag
		_userTagValidatorRexp.test userTag.toUpperCase()

	@updateUserTag: (newUserTag)->
		# newUserTag = $('#user_tag_text').value()
		newUserTag.toUpperCase()
		return false if newUserTag == @getUserTag
		return false unless @validateUserTag newUserTag

# models/todo.coffee
class Todo
	constructor: (@data, @status, @status_percentage)->

# controllers/owners.coffee
class OwnersController
	_this = null
	constructor: (@submitEL, @textEL)->
		_this = this
		Owner.getOrRequestUserTag().then (r) ->
			console.log 'asd', r
			_this.textEL.value = r
		, (r) ->
			console.log 'poi', r
			View.popMessage '#user_tag_error_msg', r.errors
	validateOwner: ->
		console.log 'OwnersController.validateOwner', _this
		View.inputStatus(
			_this.textEL,
			Owner.validateUserTag _this.textEL.value
		)
	changeOwner: ->
		console.log 'OwnersController.changeOwner', _this
		_this.submitEL.disabled = true
		Owner.updateUserTag _this.textEL.value
		.then (r) ->
			_this.submitEL.disabled = false
			if r.status
				View.popMessage '#user_tag_success_msg'
			else
				View.popMessage '#user_tag_error_msg', r.data.errors

# controllers/todos.coffee
class TodosController
	_this = null
	_todosList = null
	constructor: (@tv)-> # tv = TodosView
		_this = this
		Owner.getOrRequestUserTag().then (r) ->
			console.log 'asd', r
			_this.textEL.value = r
		, (r) ->
			console.log 'poi', r
			View.popMessage '#user_tag_error_msg', r.errors
	getTodoListAndUpdate = ->
		_this.loadingEL.classList.add 'display'
		_todosList = []
		_this.tv.cleanTodoList()
		Todo.getTodoList
		.then (r) ->
			_this.tv.fillTodoList _todosList = r.data.todos_list
			View.popMessage '#new_todo_error_msg', r.data.errors if r.data.errors
		, (r) ->
			_this.tv.fillTodoList []
			View.popMessage '#new_todo_error_msg'#, r.data.errors

# views/root.coffee
class View
	_timeOutQueue = {}
	@popMessage: (msgELID, extraCustomText)->
		console.log 'View@popMessage'
		hideMsg = ->
			msgEL.classList.remove 'display'
			extraCustomTextEL.innerHTML = ''
		msgEL = document.querySelector msgELID
		extraCustomTextEL = msgEL.querySelector 'span'
		msgEL.classList.add 'display'
		extraCustomTextEL.innerHTML = extraCustomText if extraCustomText
		clearTimeout _timeOutQueue[msgELID]
		_timeOutQueue[msgELID] = setTimeout hideMsg, 10*1000
	@inputStatus: (inputEL, is_status)->
		console.log 'View@inputStatus'
		_removeStatus = ->
			inputEL.classList.remove 'valid'
			inputEL.classList.remove 'invalid'
		_removeStatus()
		if is_status
			inputEL.classList.add 'valid'
		else
			inputEL.classList.add 'invalid'
		clearTimeout _timeOutQueue[inputEL.id]
		_timeOutQueue[inputEL.id] = setTimeout _removeStatus, 3*1000

# views/todos.coffee
class TodosView
	_this = null
	constructor: ->
		console.log 'TodosView.constructor'
		@loadingEL = document.querySelector '#todo_loading'
		@emptyEL = document.querySelector '#todo_no_items'
		@newSubmitEL = document.querySelector '#todo_new_button'
		@newTextEL = document.querySelector '#todo_new_text'
		_this = this
		tc = new TodosController _this
		addEventListener 'user_tag_update', tc.getTodoListAndUpdate
		# user_tag actions events
		# @newtextEL.onchange = tc.validateTodo # always true?...
		@newSubmitEL.addEventListener 'click', tc.createTodo, false
	_todoItemEL = (todo)->
		`` + document.querySelector('#_todo_item').innerHTML
	_listItemsEL = ->
		document.querySelectorAll '#todo_list li'

	cleanTodoList: ->
		_listItemsEL.forEach (el) ->
			el.remove()
	fillTodoList: (todosList)->
		cleanTodoList()
		@loadingEL.classList.remove 'display'
		if !todosList.length
			@emptyEL.classList.add 'display'
		else
			innerHTML = ''
			todosList.forEach (todo) ->
				innerHTML += _todoItemEL todo
# views/owners.coffee
class OwnersView
	constructor: ->
		console.log 'OwnersView.constructor'
		@submitEL = document.querySelector '#user_tag_button'
		@textEL = document.querySelector '#user_tag_text'
		oc = new OwnersController @submitEL, @textEL
		# user_tag actions events
		@textEL.onchange = oc.validateOwner
		@submitEL.addEventListener 'click', oc.changeOwner, false

MAIN = ->
	new OwnersView()
	new TodosView()

document.addEventListener 'DOMContentLoaded', MAIN, false