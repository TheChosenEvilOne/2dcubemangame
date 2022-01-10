/admin_verbs/fun
	name = "fun" // in quotation marks.

/admin_verbs/fun/proc/epilepsy()
	set name = "Epilepsy"
	set category = "Fun"
	var/client/player = input("Who to kill?", "Epilepsy") as null|anything in clients
	if (!player)
		return
	var/time = input("How terrible?\nTime in deciseconds\nTHERE IS NO GOING BACK.", "Epilepsy", 10) as null|num
	var/S = player.planes[/plane/world]
	animate(S, color = "#ff0000", loop = -1, time = time)
	animate(color = "#00ff00", time = time)
	animate(color = "#0000ff", time = time)