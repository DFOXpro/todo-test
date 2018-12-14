window.TodosView = class
	_this = null
	_todoItemELIH = null
	_tc = null # TodosController

	_processedTodoItemEL = (todo)->
		# this function because js dnt suport digest string like template literal
		processedTodoItem = String.raw(
			{raw: _todoItemELIH},
			todo.id,
			todo.data,
			todo.status_percentage||0,
			if todo.status then 'checked' else ''
		)
		# console.log processedTodoItem
		processedTodoItem

	_listItemsEL = ->
		document.querySelectorAll '#todo_list li'

	constructor: ->
		console.log 'TodosView.constructor'
		@loadingEL = document.querySelector '#todo_loading'
		@emptyEL = document.querySelector '#todo_no_items'
		@todosListEL = document.querySelector 'ul#todo_list'
		_todoItemELIH = document.querySelector('#_todo_item').innerHTML.split '$'
		@newSubmitEL = document.querySelector '#todo_new_button'
		@newTextEL = document.querySelector '#todo_new_text'
		_this = this
		_tc = new TodosController _this
		# todos actions events
		# @newtextEL.onchange = tc.validateTodo # always true?...
		@newSubmitEL.addEventListener 'click', _tc.createTodo, false

	toggleTodoInputDisable: (isDisabled) ->
		_this.newSubmitEL.disabled = isDisabled
		_this.newTextEL.disabled = isDisabled
	cleanTodoList: ->
		_listItemsEL().forEach (el) ->
			el.remove()
	fillTodoList: (todosList)->
		console.log 'TodosView.fillTodoList', todosList
		_this.cleanTodoList()
		@loadingEL.classList.remove 'display'
		if !todosList.length
			@emptyEL.classList.add 'display'
		else
			_addEventToButton = (querySelector, fun) ->
				document.querySelector querySelector
				.addEventListener 'click', fun, false

			todosList.forEach (todo, index) ->
				_this.todosListEL.innerHTML += _processedTodoItemEL todo
				_deleteTodo = ->
					_tc.deleteTodo(
						todo.id
						index
					)

				_updateTodo = ->
					_tc.updateTodo(
						id: todo.id
						data: `document.querySelector(\`li#todo_${todo.id} .todo_text\`).value`
						status: `document.querySelector(\`li#todo_${todo.id} .todo_status\`).checked`
						status_percentage: `document.querySelector(\`li#todo_${todo.id} .todo_status_percentage\`).value`
						index
					)
				setTimeout ->
					_addEventToButton `\`li#todo_${todo.id} .todo_update\``, _updateTodo
					_addEventToButton `\`li#todo_${todo.id} .todo_delete\``, _deleteTodo
				, 160
