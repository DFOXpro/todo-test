window.TodosController = class
	_this = null
	_todosList = null

	constructor: (@tv)-> # tv = TodosView
		console.log 'TodosController.constructor'
		_this = this
		if window.user_tag_ready
			console.log 'utr'
			_this.getTodoListAndUpdate()
		else
			console.log 'utw'
			addEventListener 'user_tag_update', _this.getTodoListAndUpdate

	getTodoListAndUpdate: (user_tag)->
		console.log 'TodosController.getTodoListAndUpdate', user_tag
		_todosList = []
		_this.tv.cleanTodoList()
		_this.tv.loadingEL.classList.add 'display'
		_this.tv.toggleTodoInputDisable true

		Todo.getTodoList(user_tag)
		.then (todosList) ->
			_this.tv.fillTodoList _todosList = todosList
			_this.tv.toggleTodoInputDisable false
		# , (r) ->
		# 	_this.tv.fillTodoList []
		# 	View.popMessage '#new_todo_error_msg'#, r.data.errors

	createTodo: ->
		todoText = _this.tv.newTextEL.value + ''
		return false if !todoText
		_this.tv.toggleTodoInputDisable true
		Todo.createTodo data: todoText
		.then (todo) ->
			_todosList.push todo
			_this.tv.fillTodoList _todosList
			_this.tv.toggleTodoInputDisable false
			_this.tv.newTextEL.value = ''
			View.popMessage '#new_todo_success_msg'
		# , (r) ->
		# 	_this.tv.fillTodoList []
		# 	View.popMessage '#new_todo_error_msg'#, r.data.errors

	updateTodo: (todo, index)->
		console.log 'TodosController@updateTodo', todo, index
		return false if _todosList[index].id != todo.id
		_todosList[index].updateTodo todo
		.then (is_updated)->
			_todosList[index] = todo
			View.popMessage '#new_todo_success_msg'

	deleteTodo: (todoId, index)->
		console.log 'TodosController@deleteTodo', todoId, index, _todosList[index]
		return false if _todosList[index].id != todoId
		Todo.deleteTodo todoId
		.then (is_deleted)->
			if is_deleted
				_todosList.splice index, 1
				_this.tv.fillTodoList _todosList
				View.popMessage '#new_todo_success_msg'
