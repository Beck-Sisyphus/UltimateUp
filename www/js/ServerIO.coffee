# coffeelint: disable=no_tabs

class ServerIO extends EventEmitter
	constructor: (@url) ->
		@super()
		@socket = null
		@msgQueue = []
		@reqCallbacks = []
		@queueTimer = null

		@socketInit()

	socketInit: () ->
		socket = @socket = new WebSocket @url

		# bind events
		socket.onopen = onOpen
		socket.onmessage = onMessage
		socket.onclose = onClose
		socket.onerror = onError

	onMessage: (e) =>
		data = JSON.parse e.data
		if data.type == 'push'
			@emit data.kind, data
		else if data.type == 'res'
			@reqCallbacks[data.id] data

	maybeSendMsg: ->
		if !@queueTimer && @msgQueue.length != 0
			@queueTimer = setTimeout @_sendMsg, 0			

	_sendMsg: =>
		@queueTimer = null
		if @socket.readyState == WebSocket.OPEN
			@socket.send @msgQueue.unshift()
		@maybeSendMsg()

	onOpen: =>
		# send buffered msgs
		@maybeSendMsg()

	onClose: (e) =>
		console.error e
		# FIXME: exponential backup
		@socketInit()

	onError: (err) =>
		console.error err

	fetch: (req) ->
		new Promise (resolve, reject) ->
			req.type = req.type | "req"
			rand = new Uint32Array 1
			window.crypto.getRandomValues rand
			id = req.id = rand[0]
			@reqCallbacks[id] = (err, data) ->
				if err
					reject err
				else
					resolve data

			@msgQueue.push JSON.stringify req
			@maybeSendMsg()

	# @on: not necessarily since EventEmitter handles it
