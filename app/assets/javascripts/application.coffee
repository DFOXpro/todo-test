#= require_tree .

MAIN = ->
	new OwnersView()
	new TodosView()

document.addEventListener 'DOMContentLoaded', MAIN, false
