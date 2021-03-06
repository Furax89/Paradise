/datum/event/vent_clog
	announceWhen	= 0
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()

/datum/event/vent_clog/announce()
	command_announcement.Announce("The scrubbers network is experiencing a backpressure surge.  Some ejection of contents may occur.", "Atmospherics alert")


/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in machines)
		if((temp_vent.loc.z in config.station_levels) && temp_vent.network)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/vent = pick_n_take(vents)

		var/list/gunk = list("water","carbon","flour","radium","toxin","cleaner","nutriment","condensedcapsaicin","psilocybin","lube",
							"atrazine","banana","charcoal","space_drugs","methamphetamine","holywater","ethanol","hot_coco","facid",
							"blood","morphine","fluorine","mutadone","mutagen","hydrocodone","fuel","cryptobiolin",
							"haloperidol","mindbreaker","nanites","lipolicide","frostoil","salglu_solution","beepskysmash",
							"omnizine", "amanitin", "adminordrazine", "neurotoxin", "synaptizine")
		var/datum/reagents/R = new/datum/reagents(50)
		R.my_atom = vent
		R.add_reagent(pick(gunk), 50)

		var/datum/effect/effect/system/chem_smoke_spread/smoke = new
		smoke.set_up(R, rand(1, 2), 0, vent, 0, silent = 1)
		playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		smoke.start(3)
		R.delete()	//GC the reagents
