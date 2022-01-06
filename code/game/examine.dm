/atom/proc/examine_message()
	return ""

/atom/verb/examine()
	set name = "Examine"

	usr << "That is \a [src]."
	if (desc) usr << "[desc]"
	var/M = examine_message()
	if (M) usr << "[M]"

/atom/left_click(adjacent, params)
	if (!params["shift"])
		return ..()
	examine()