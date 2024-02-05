/obj/boombox
	name = "boombox"
	desc = "A device made for playing music, cool."
	icon_state = "boombox"
	interactable = TRUE
	var/in_use = FALSE
	var/last_use = 0

/obj/boombox/interact(who)
	if (last_use > world.time)
		who << "It has been used too recently."
		return
	if (in_use)
		who << "Someone is already using that."
		return
	in_use = TRUE
	var/sound/S = input("Select a sound file.") as null|sound
	if (!S)
		in_use = FALSE
		return
	S = sound(S)
	S.channel = 1024
	hearers() << S
	last_use = world.time + 100 // 10 second delay
	in_use = FALSE