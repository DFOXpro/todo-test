window.Todo = class
	_this = null

	_setAttributes = (todo) ->
		_this.id = todo.id
		_this.data = todo.data
		_this.status = todo.status
		_this.status_percentage = todo.status_percentage
		_this.created_at = todo.created_at
		_this.updated_at = todo.updated_at

	constructor: (todoHash)->
		_this = this
		_setAttributes todoHash

	@getTodoList: (user_tag)->
		user_tag = user_tag || Owner.getUserTag()
		console.log 'Todo@getTodoList', user_tag
		new Promise (resolve, reject)->
			xhr ROUTES.API.api.v1.todos.list, query: user_tag: user_tag
			.then (r)->
				todosList = r.data.todos.map (t) ->
					new Todo t
				resolve todosList
		# .then reject

	@createTodo: (newTodo) ->
		new Promise (resolve, reject)->
			xhr ROUTES.API.api.v1.todos.create, null, {
				todo: newTodo
				user_tag: Owner.getUserTag()
			}
			.then (r)->
				resolve new Todo r.data.todo

	updateTodo: (newTodo)->
		_setAttributes newTodo
		console.log 'Todo@updateTodo', _this.toHash()
		new Promise (resolve, reject)->
			xhr ROUTES.API.api.v1.todos.update, {todo_id: _this.id}, {
				todo: _this.toHash()
				user_tag: Owner.getUserTag()
			}
			.then (r)->
				resolve r.data.update

	@deleteTodo: (todoId)->
		console.log 'Todo@deleteTodo', todoId
		new Promise (resolve, reject)->
			xhr ROUTES.API.api.v1.todos.delete, {
				todo_id: todoId
				query: user_tag: Owner.getUserTag()
			}
			.then (r)->
				resolve r.data.delete

	toHash: ->
		{
			id: _this.id
			data: _this.data
			status: _this.status
			status_percentage: _this.status_percentage
			created_at: _this.created_at
			updated_at: _this.updated_at
		}
