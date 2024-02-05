/datum/map_gen
	var/size_x
	var/size_y
	var/count
	var/order
	var/static/list/instructions = list(
		"FILL" = /datum/map_gen/proc/fill,
		"LIFE" = /datum/map_gen/proc/life
		)
	var/list/program
	var/list/write
	var/list/read
	var/list/out
	var/list/scratch
	var/list/stores = list()

/datum/map_gen/New(prg)
	program = prg
	size_x = world.maxx
	size_y = world.maxy
	scratch = new(world.maxx, world.maxy)
	out = new(world.maxx, world.maxy)
	. = ..()

/datum/map_gen/proc/apply(z)
	for (var/x in 1 to size_x)
		for (var/y in 1 to size_y)
			var/turf/T = locate(x, y, z)
			out[x][y] & 1 ? new /turf/wall(T) : new /turf/floor/gray(T)

/datum/map_gen/proc/get_store(store)
	if (store == "scratch") return scratch
	else if (store == "out") return out
	else if (!stores[store]) return stores[store] = new(world.maxx, world.maxy)
	return stores[store]

#define INDEX(list, index) (length(list)<index?null:list[index])
#define INDEX_SET(var, list, index, default) if (length(list)<index) {##var=##default} else {##var=list[index]}
#define MODIFIER_DEFAULT(modifier, name, default) ##modifier = inst[3][name]; if (##modifier) {##modifier = ##modifier[2][1]} else {##modifier = default};
#define MAP_INSTRUCTION_DEFAULT(function) \
switch (order) { \
if("seq") { \
for (var/i in 1 to count) { \
for (var/x in 1 to size_x) { \
for (var/y in 1 to size_y) { \
if(1) {##function}; \
}}} \
} if ("rand") { \
for (var/i in 1 to count) { \
var/x = rand(1, size_x); \
var/y = rand(1, size_y); \
if(1) {##function}; \
}}}

/datum/map_gen/proc/generate()
	for (var/list/inst in program)
		var/instproc = instructions[inst[1]]
		MODIFIER_DEFAULT(order, "ORDER", "seq")
		MODIFIER_DEFAULT(count, "COUNT", 1)
		count = text2num(count)
		var/_to = inst[3]["TO"]
		if (_to) write = get_store(_to[2][1])
		else write = scratch
		var/_in = inst[3]["IN"]
		if (_in) read = get_store(_in[2][1])
		else read = out
		call(src, instproc)(inst[2])
//		if (write == scratch)
		out = write
		scratch = read
	out = write

#undef MODIFIER_DEFAULT

/datum/map_gen/proc/fill(arguments)
	var/chance = arguments[1] ? text2num(arguments[1]) : 100
	MAP_INSTRUCTION_DEFAULT(\
		write[x][y] = prob(chance) + (read[x][y] & (~1))\
	)

#define BEGIN {
#define END }

/datum/map_gen/proc/life(arguments)
	var/static/list/directions = list(0, 1, -1, 1, 1, 0, -1, -1, 0)
	var/list/begin = list()
	var/list/stay = list()
	var/rule = splittext(arguments[1], "/")
	var/edge_type
	INDEX_SET(edge_type, arguments, 2, 1)
	var/n_count
	for (var/c in 1 to length(rule[1]))	begin += text2num(rule[1][c])
	for (var/c in 1 to length(rule[2]))	stay += text2num(rule[2][c])

	MAP_INSTRUCTION_DEFAULT(\
		n_count = 0;\
		for (var/d in 1 to length(directions) - 1) BEGIN \
			var/nX = x + directions[d]; var/nY = y + directions[d + 1]; \
			if (nY < 1 || nY > size_y || nX < 1 || nX > size_x) BEGIN \
				n_count += edge_type; \
			END else BEGIN n_count += read[nX][nY] & 1; END END \
		if (n_count in begin) BEGIN write[x][y] = 1 + (read[x][y] & (~1)); END \
		else if (!(n_count in stay)) BEGIN write[x][y] = 0 + (read[x][y] & (~1)); END \
		else BEGIN write[x][y] = read[x][y]; END)

#undef MAP_INSTRUCTION_DEFAULT
#undef BEGIN
#undef END
#undef INDEX
#undef INDEX_SET

/proc/parse_mapgen(text)
	var/static/list/instructions = list(
		"FILL", "LIFE"
	)
	var/static/list/modifiers = list(
		"IN", "TO", "COUNT", "ORDER"
	)
	var/list/lines = splittext(text, ";")
	var/list/program = list()
	for (var/line in lines)
		var/list/instruction = list("", null, list())
		var/list/current = instruction
		var/from = findtext(line, " ")
		var/inst = uppertext(trimtext(copytext(line, 1, from)))
		line = trimtext(copytext(line, from))
		if (!inst) continue
		if (!(inst in instructions))
			usr << "Invalid instruction [inst]"
			return
		instruction[1] = inst
		program.Add(list(instruction))
		read_args:
		var/list/arguments = list()
		var/buffer = ""
		var/d = FALSE
		var/c = FALSE
		var/i = 1
		for (i in 1 to length(line))
			switch (line[i])
				if (" ")
					c = !d
				if (",")
					if (d) continue
					arguments += trimtext(buffer)
					buffer = ""
					c = FALSE
				if ("\"")
					if (line[i - 1] == "\\") buffer += line[i]
					d = !d
				else
					if (c) break
					buffer += line[i]
		if (buffer) arguments += trimtext(buffer)
		current[2] = arguments
		if (i >= length(line)) continue
		line = trimtext(copytext(line, i))
		from = findtext(line, " ")
		var/modf = uppertext(trimtext(copytext(line, 1, from)))
		line = trimtext(copytext(line, from))
		if (!modf || !line) continue
		if (!(modf in modifiers))
			usr << "Invalid modifier [modf]"
			return
		current = list(modf, null)
		instruction[3][modf] = current
		goto read_args
	var/datum/map_gen/gen = new(program)
	gen.generate()
	gen.apply(usr.z)

/datum/map_generator

/datum/map_generator/proc/configure()

/datum/map_generator/proc/generate(x, y, z)