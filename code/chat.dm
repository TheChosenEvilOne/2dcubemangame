/atom
	var/messages = list()

/atom/movable/abstract/chat_message
	appearance_flags = RESET_COLOR | RESET_ALPHA
	maptext_width = 256
	maptext_height = 64
	maptext_y = 30
	maptext_x = -112
	vis_flags = NONE
	plane = UI_PLANE
	layer = OVER_LIGHTING_LAYER

/atom/movable/abstract/chat_message/New(atom/movable/A, words)
	maptext = CENTERTEXT(MAPTEXT(LARGETEXT(words)))
	for (var/atom/M as anything in A.messages)
		M.pixel_y += 16
	A.messages += src
	A.vis_contents += src
	animate(src, alpha = 0, time = 40)
	spawn (40)
		vis_contents -= src
		A.messages -= src
		del src

/client/verb/ooc(words as text)
	set name = "OOC"
	if (!words)
		return
	words = html_encode(words)
	world << "<div style='color: blue'><b>[src]</b>: [words]</div>"

/client/verb/say(words as text)
	set name = "Say"
	if (!words)
		return
//	winset(src, "say", "is-visible=false")
	words = html_encode(words)
	mob.say(words)

/client/verb/me(words as text)
	set name = "Me"
	if (!words)
		return
	words = html_encode(words)
	mob.act(words)

/client/proc/glorf(glorf)
/*	var/text = winget(src, "say-input", "text")
	if (text)
		text += "-[glorf]"
		say(text)
		winset(src, "say-input", "text=''")*/