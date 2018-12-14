window.View = class
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
