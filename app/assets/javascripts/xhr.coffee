# xhr.coffee
# this is just a wannabe of ajax or angular's $http
window.xhr = (trochaRoute, pathArgs, data)->
	pathArgs = pathArgs || {}
	pathArgs.post = true
	# console.log 'xhr', trochaRoute, pathArgs, data
	oReq = new XMLHttpRequest()
	xhrHandler = (handler)->
		(e)->
			r =
				data: JSON.parse(oReq.response)
				event: e
			console.log 'XHR load', r, trochaRoute, pathArgs, data
			handler r
	new Promise (resolve, reject)->
		# oReq.addEventListener("progress", updateProgress);
		oReq.addEventListener 'load', xhrHandler resolve
		oReq.addEventListener 'error', xhrHandler reject
		# oReq.addEventListener("abort", transferCanceled);

		oReq.open(
			trochaRoute.$method,
			trochaRoute.path pathArgs
		)
		if data
			oReq.setRequestHeader "Content-Type", "application/json"
			oReq.send JSON.stringify data
		else oReq.send()

# Trocha Routes
APIResource =
	show: {$hide: true}
	list: {$id: false, $hide: true}
	create: {$hide: true, $id: false, $method: trocha.POST}
	update: {$hide: true, $method: trocha.PATCH}
	delete: {$hide: true, $method: trocha.DELETE}
# this should be no public ¬¬
window.ROUTES =
	API: trocha
		post: '.json'
		alwaysPost: true
		resource: APIResource
		routes: api: v1:
			owners:
				$type: trocha.RESOURCE
				# note: list & delete return 404
				$id: "user_tag" # like owner_id
			todos:
				$type: trocha.RESOURCE
				$id: "todo_id"
