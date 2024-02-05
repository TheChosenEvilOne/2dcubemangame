SYSTEM_CREATE(config)
	name = "configuration"
	flags = S_INIT
	priority = -100
	var/list/configs = list()

/system/config/initialize()
	for (var/f in flist("config/"))
		configs += parse_file("config/[f]")

#define TRIM(s) replacetext(s, regex("^\\s*(.*?)\\s*$", "g"), "$1")
/system/config/proc/parse_file(file)
	var/t = file2text(file)
	var/sections = splittext(t, "\[")
	for (var/s in sections)
		var/c = copytext(s, 1, findtext(s, "]"))
		if (!configs[c])
			configs[c] = list()
		var/lines = splittext(copytext(s, findtext(s, "\n")), "\n")
		for (var/l in lines)
			if (!l)
				continue
			l = splittext(l, "=")
			var/key = TRIM(l[1])
			var/value = TRIM(l[2])
			if (value[1] == "{")
				value = parse_array(value)
			configs[c][key] = value

/system/config/proc/parse_array(text)
	text = copytext(text, 2, -1)
	var/is_array = FALSE
	var/list/split = list()
	var/curr
	var/depth = 0
	var/key
	for (var/i in 1 to length(text))
		var/c = text[i]
		if (c == ":")
			key = TRIM(curr)
			curr = ""
			continue
		else if (c == "{")
			depth++
			is_array = TRUE
		else if (c == "}")
			depth--
		else if (c == "," && !depth)
			curr = TRIM(curr)
			if (key)
				split[key] = is_array ? parse_array(curr) : curr
				key = ""
			else
				split += is_array ? parse_array(curr) : curr
			is_array = FALSE
			curr = ""
			continue
		curr += c
	curr = TRIM(curr)
	if (key)
		split[key] = curr
	else
		split += curr
	return split
#undef TRIM