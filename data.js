{
	"Synchronous (once per frame)" : {
		"/shape" : [type (String), id (int), width (float), height (float), sides (int)],
		"/boundary" : [id (int), width (float), height (float), hue (int [0, 360))],
		"/hand": [id (int)]
	},
	"Asynchronous (on event)" : {
		"/contact" : [] // collision handling
	}
}