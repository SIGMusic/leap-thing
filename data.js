{
	"Synchronous (once per frame)" : {
		"/shape" : [type (String), id (int), width (float), height (float), sides (int)],
		"/boundary" : [id (int), width (float), height (float), hue (int [0, 360))],
		"/hand": [id (int), x_pos (float), y_pos (float)],
		"/finger": [hand_id (int), finger_id (int), x_pos (float), y_pos (float)]
	},
	"Asynchronous (on event)" : {
		"/contact" : [] // collision handling
	}
}