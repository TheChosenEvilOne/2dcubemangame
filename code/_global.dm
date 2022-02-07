// Don't put global variables here unless you REALLY need to.
// Acceptable cases are when you need to use the variable before master has initialized.
// Or when it is more convenient to use them directly (like the clients list).
var/global/datum/master/master
var/global/list/client/clients