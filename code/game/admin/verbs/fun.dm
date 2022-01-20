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

/admin_verbs/fun/proc/size_increase()
	set name = "Increase Map Size"
	set category = "Fun"
	var/x = input("X size", "Map Size", world.maxx) as null|num
	if (!x)
		return
	var/y = input("Y size", "Map Size", world.maxy) as null|num
	if (!y)
		return
	if (x <= world.maxy || y <= world.maxy)
		return
	if ((x - world.maxx) >= 100 || (y - world.maxy) >= 100)
		if (alert("WARNING, THIS WILL LAG THE SERVER.", "Map Size", "I understand", "STOP") == "STOP")
			return
	world.maxx = x
	world.maxy = y