{
	"Synchronous (once per frame)" : {
		"/shape" : [type (String), id (int), width (float), height (float), sides (int), x_vel (float), y_vel (float), ang_vel (float)],
		"/boundary" : [id (int), width (float), height (float), hue (int [0, 360))],
		"/hand": [id (int), x_pos (float), y_pos (float), stab_x_pos (float), stab_y_pos (float), x_dir (float), y_dir (float), roll (float), pitch (float), yaw (float), t (float), sp_x_pos (float), sp_y_pos (float), radius (float)],
		"/finger": [hand_id (int), finger_id (int), x_pos (float), y_pos (float)],
		"/background": [cur_hue (float), avg_hue (int)]
	},
	"Asynchronous (on event)" : {
		"/contact" : [type1 (String), id1 (int), type2 (String), id2] // collision handling
	}
}

