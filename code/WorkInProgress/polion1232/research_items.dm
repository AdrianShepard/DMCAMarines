/////////////
// Useful auxiliary equipment
/////////////

/obj/item/reagent_container/spray/anti_weed
	name = "Weed-B-Gone Sprayer"
	desc = "Sprayer and canister, filled with Plant-B-Gone to burst. Spraying distance is horrifyingly large. Those xeno scums will definatly hate you."
	icon = 'code/WorkInProgress/polion1232/polionresearch.dmi'
	icon_state = "weed-killer"
	item_state = "weed-killer"

	throwforce = 3
	spray_size = 3
	w_class = 4.0
	possible_transfer_amounts = null
	volume = 1000

/obj/item/reagent_container/spray/anti_weed/New()
	..()
	reagents.add_reagent("plantbgone", 1000)

/obj/item/reagent_container/spray/anti_weed/Spray_at(atom/A)
	var/obj/effect/decal/chempuff/D = new/obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(spray_size * amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1/spray_size)
	D.color = mix_color_from_reagents(D.reagents.reagent_list)

	var/direction = get_dir(src, A)
	var/turf/A_center = get_turf(A)//BS12
	var/turf/A_left = get_step(A_center, turn(direction, 90))
	var/turf/A_right = get_step(A_center, turn(direction, -90))

	var/obj/effect/decal/chempuff/Right = new/obj/effect/decal/chempuff(get_turf(src))
	Right.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(Right, amount_per_transfer_from_this, 1/spray_size, 1)
	Right.color = mix_color_from_reagents(D.reagents.reagent_list)
	Right.dir = turn(direction, -45)

	var/obj/effect/decal/chempuff/Left = new/obj/effect/decal/chempuff(get_turf(src))
	Left.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(Left, amount_per_transfer_from_this, 1/spray_size, 1)
	Left.color = mix_color_from_reagents(D.reagents.reagent_list)
	Left.dir = turn(direction, 45)

	var/spray_dist = spray_size
	spawn(0)
		for(var/i=0, i<spray_dist, i++)
			step_towards(D,A)
			step(Right, Right.dir)
			step(Left, Left.dir)
			Right.dir = direction
			Left.dir = direction
			D.reagents.reaction(get_turf(D))
			Right.reagents.reaction(get_turf(Right))
			Left.reagents.reaction(get_turf(Left))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)

				// When spraying against the wall, also react with the wall, but
				// not its contents. BS12
				if(get_dist(D, A_center) == 1 && A_center.density)
					D.reagents.reaction(A_center)
			for(var/atom/T in get_turf(Left))
				Left.reagents.reaction(T)
				if(get_dist(Left, A_left) == 1 && A_left.density)
					Left.reagents.reaction(A_left)
			for(var/atom/T in get_turf(Right))
				Right.reagents.reaction(T)
				if(get_dist(Right, A_right) == 1 && A_right.density)
					Right.reagents.reaction(A_right)
				sleep(2)
			sleep(3)
		cdel(D)
		cdel(Left)
		cdel(Right)

/obj/item/cell/xba
	name = "XBA-based power cell"
	icon_state = "scell"
	maxcharge = 20000

/obj/item/cell/xba/high
	name = "XBA-based high-capacity power cell"
	icon_state = "scell"
	maxcharge = 40000

/obj/item/anti_acid
	name = "Acid-Kill Spray"
	desc = "Small sprayer, filled with special mixture of alkalies that can neutralize even xenomorphs' acids."
	icon = 'code/WorkInProgress/polion1232/polionresearch.dmi'
	icon_state = "anti-acid"
	item_state = "anti-acid"
	var/max_use = 10
	var/use_time				//1 against weak acid, 5 - acid, Strong acid is unpurgeable

/obj/item/anti_acid/New()
	..()
	use_time = max_use

/////////////
// Guns, their ammo datums and ect.
/////////////

/obj/item/weapon/gun/energy/tesla			//ZZZZZZZZZAP
	name = "HEW-2 \"Zeus\""
	//name = "ESW MKIV \"Paralyzer\""		//
	desc = "The actual firearm in 2-piece HEW(Heavy Electrical Weapon) system MKII. Being civilian-grade gun system, primary used by scientific divisions, that gun can still be useful for USCM in limited numbers."
	icon_state = "m56"
	item_state = "m56"
	ammo = /datum/ammo/energy/tesla
	fire_sound = 'sound/weapons/Tesla.ogg'
	var/charge_cost = 100
	var/charge = 0			//prepered charge
	gun_skill_category = GUN_SKILL_SMARTGUN		//Heavy as fuck
	flags_gun_features = GUN_INTERNAL_MAG|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/energy/tesla/set_gun_config_values()
	fire_delay = config.max_fire_delay * 2
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = 0
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult

/obj/item/weapon/gun/energy/tesla/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.smartgun < SKILL_SMART_USE)
			to_chat(user, "<span class='warning'>You don't seem to know how to use [src]...</span>")
			return 0
	return 1

/obj/item/weapon/gun/energy/tesla/load_into_chamber()
	if(charge - charge_cost < 0) return

	charge -= charge_cost
	in_chamber = create_bullet(ammo)
	return in_chamber

/obj/item/weapon/gun/energy/tesla/reload_into_chamber(mob/user)			//To not listening for annoying *click*
	return 1

/obj/item/weapon/gun/energy/tesla/reload(mob/gunner, obj/item/tesla_powerpack/power_pack)
	if(!(power_pack && power_pack.loc))
		return
	if(charge == charge_cost)
		return
	power_pack.attack_self(gunner, charge_cost)



/obj/item/tesla_powerpack
	name = "HEW-2 Recharge Powerpack"
	desc = "A pretty fragile backpack with support equipment and power cells for \"Zeus\" discharger.\nClick the icon in the top left to reload your M56."
	icon = 'icons/obj/items/storage/storage.dmi'
	icon_state = "powerpack"
	flags_atom = CONDUCT
	flags_equip_slot = SLOT_BACK
	w_class = 5.0
	actions_types = list(/datum/action/item_action/toggle)
	var/obj/item/cell/charge_battery = null
	var/reloading = FALSE

/obj/item/tesla_powerpack/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell))
		var/obj/item/cell/C = A
		visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [C.charge] power.")
		charge_battery.loc = get_turf(user)
		charge_battery = C
		C.loc = src
		playsound(src,'sound/machines/click.ogg', 25, 1)
	else
		..()

/obj/item/tesla_powerpack/New()
	select_gamemode_skin(/obj/item/smartgun_powerpack)
	..()
	charge_battery = new /obj/item/cell/high()

/obj/item/tesla_powerpack/proc/reload(mob/user, obj/item/weapon/gun/energy/tesla/mygun)
	mygun.charge = mygun.charge_cost
	charge_battery.charge -= mygun.charge
	reloading = FALSE

/obj/item/tesla_powerpack/attack_self(mob/user, charge_cost)
	if(!ishuman(user) || user.stat) return 0

	var/obj/item/weapon/gun/energy/tesla/mygun = user.get_active_hand()

	if(isnull(mygun) || !mygun || !istype(mygun))
		to_chat(user, "You must be holding an HEW-2 \"Zeus\" to begin the reload process.")
		return
	if(charge_battery.charge < mygun.charge_cost)
		to_chat(user, "Your powerpack is completely drained! Looks like you're up shit creek, maggot!")
		return
	if(!charge_battery)
		to_chat(user, "Your powerpack doesn't have a battery! Slap one in there!")
		return

	if(reloading)
		return

	reloading = TRUE
	user.visible_message("[user.name] begins recharging tesla coil.","You begin recharging tesla coil. Don't move or you'll be interrupted.")
	var/reload_duration = 50
	if(user.mind && user.mind.cm_skills && user.mind.cm_skills.smartgun>0)
		reload_duration = max(reload_duration - 10*user.mind.cm_skills.smartgun,30)
	if(do_after(user,reload_duration, TRUE, 5, BUSY_ICON_FRIENDLY))
		reload(user, mygun)
		to_chat(user, "<span class='notice'>You recharged tesla capacitor. Shock therapy!</span>")
	else
		to_chat(user, "Your recharging was interrupted!")
		playsound(src,'sound/machines/buzz-two.ogg', 25, 1)
		reloading = FALSE
		return
	return 1

/datum/ammo/energy/tesla
	name = "tesla bolt"
	icon_state = "ion"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_ARMOR

/datum/ammo/energy/tesla/New()
	..()
	damage = config.min_hit_damage
	max_range = config.short_shell_range
	shell_speed = config.ultra_shell_speed
	accuracy = config.max_hit_accuracy
	scatter = 0

/datum/ammo/energy/tesla/on_hit_mob(mob/M, obj/item/projectile/P)
	stun_living(M, P)
	if(isYautja(M))
		return
	if(M.canmove)
		var/mob/living/carbon/Xenomorph/target = M
		if(!(isXenoQueen(M) || isXenoRavager(target)))
			M.visible_message("<span class='danger'>[M.name] roared and fallen down.</span>","<span class='userdanger'>You feel like your own nerves stopped working!</span>")
			target.apply_effects(8,8)									// I suppose, it's a three seconds
			return
		if(isXenoQueen(M) || isXenoRavager(target))
			target.visible_message("<span class='danger'>Tesla discharge was been shrugged off [target.name]'s chitin!</span>", "You felt weird thing, that pokes your chitin")

// Laser Gun
/obj/item/weapon/gun/energy/lasgan
	name = "SR-LG \"Thunder\""
	desc = "First working prototype of \"Laser Gun\"-series of 1st generation laser weapon, deliver death and destruction on its path."
	icon = 'icons/obj/old_guns/old_guns.dmi'
	icon_state = "laser"
	item_state = "FP9000"
	ammo = /datum/ammo/energy/lasgan
	fire_sound = 'sound/weapons/laser3.ogg'
	w_class = 4.0

	var/charge_cost = 100
	var/obj/item/cell/xba/mag = null
	flags_gun_features = GUN_INTERNAL_MAG

/obj/item/weapon/gun/energy/lasgan/New()
	..()
	mag = new /obj/item/cell/xba

/obj/item/weapon/gun/energy/lasgan/set_gun_config_values()
	fire_delay = config.max_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = 0
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult

/obj/item/weapon/gun/energy/lasgan/update_icon()
	var/charge = (mag.charge * 100)/mag.maxcharge
	if(charge <= 100 && charge >=75)
		icon_state = "laser100"
		return
	if(charge < 75 && charge >= 50)
		icon_state = "laser75"
		return
	if(charge < 50 && charge >= 25)
		icon_state = "laser50"
		return
	if(charge < 25 && charge > 0)
		icon_state = "laser25"
		return
	if(charge == 0)
		icon_state = "laser0"
		return
	return

/obj/item/weapon/gun/energy/lasgan/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell/xba))
		var/obj/item/cell/C = A
		user.drop_held_item()
		visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [C.charge] power.")
		mag.loc = get_turf(user)
		mag = C
		C.loc = src
		playsound(src,'sound/machines/click.ogg', 25, 1)
		update_icon()
	else
		..()

/obj/item/weapon/gun/energy/lasgan/load_into_chamber()
	if(mag.charge - charge_cost < 0) return

	mag.charge -= charge_cost
	in_chamber = create_bullet(ammo)
	update_icon()
	return in_chamber

/obj/item/weapon/gun/energy/lasgan/reload_into_chamber(mob/user)			//To not listening for annoying *click*
	return 1

/datum/ammo/energy/lasgan
	name = "lasbolt"
	icon_state = "laser"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_INCENDIARY

/datum/ammo/energy/lasgan/New()
	..()
	damage = config.high_hit_damage
	max_range = config.short_shell_range
	shell_speed = config.ultra_shell_speed
	accuracy = config.max_hit_accuracy
	scatter = 0

/obj/item/weapon/gun/energy/lascannon
	name = "HG-LG \"Celatid\""
	desc = "Powerful laser cannon, \"Celatid\" may can only firing one bolt per cell, yet that bolt deliver heavy injures and can kill human in a instance."
	icon = 'icons/obj/old_guns/old_guns.dmi'
	icon_state = "lasercannon"
	item_state = "FP9000"
	ammo = /datum/ammo/energy/lasgan
	fire_sound = 'sound/weapons/emitter2.ogg'
	w_class = 5.0

	var/charge_cost = 20000
	var/obj/item/cell/xba/shot = null
	flags_gun_features = GUN_INTERNAL_MAG|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/energy/lascannon/update_icon()
	if(shot.charge > 0)
		icon_state = "lasercannon"
	else
		icon_state = "lasercannon0"

/obj/item/weapon/gun/energy/lascannon/New()
	..()
	shot = new /obj/item/cell/xba
	update_icon()

/obj/item/weapon/gun/energy/lascannon/set_gun_config_values()
	fire_delay = config.max_fire_delay*5
	accuracy_mult = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = 0
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult + config.base_hit_damage_mult + config.max_hit_damage_mult + config.max_hit_damage_mult

/obj/item/weapon/gun/energy/lascannon/reload_into_chamber(mob/user)			//To not listening for annoying *click*
	return 1

/obj/item/weapon/gun/energy/lascannon/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell))
		if(!istype(A,/obj/item/cell/xba))
			to_chat(user, "This cell contains less charge than needed.")
			return
		if(shot)
			user.drop_held_item()
			visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
			shot.loc = get_turf(user)
			shot = A
			A.loc = src
			playsound(src,'sound/machines/click.ogg', 25, 1)
		else
			user.drop_held_item()
			visible_message("[user.name] put new power cell in the [src.name].","You put new power cell in the [src].")
			shot = A
			A.loc = src
		update_icon()
	else
		..()

/obj/item/weapon/gun/energy/lascannon/load_into_chamber()
	if(!istype(shot,/obj/item/cell/xba))		//somehow
		return
	if(shot.charge == 0)
		return
	shot.charge -= charge_cost
	update_icon()
	in_chamber = create_bullet(ammo)
	return in_chamber

/obj/item/weapon/gun/energy/laspistol
	name = "CP-LG \"PocketShock\""
	desc = "Much more weaker compare to its older sisters, \"PocketShock\" provides enough self-defense for our marines and can even kill lone enemy."
	icon = 'icons/obj/old_guns/old_guns.dmi'
	icon_state = "energykill100"
	item_state = "gun"
	ammo = /datum/ammo/energy/lasgan
	fire_sound = 'sound/weapons/laser3.ogg'

	var/charge_cost = 50
	var/obj/item/cell/xba/mag = null
	flags_gun_features = GUN_INTERNAL_MAG

/obj/item/weapon/gun/energy/laspistol/New()
	..()
	mag = new /obj/item/cell/xba
	update_icon()

/obj/item/weapon/gun/energy/laspistol/set_gun_config_values()
	fire_delay = config.max_fire_delay*2
	accuracy_mult = config.base_hit_accuracy_mult + config.base_hit_accuracy_mult	//small damage but ABSOLUTELY DISGUSTING ACCURACY
	accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult + config.max_hit_accuracy_mult
	scatter = 0
	scatter_unwielded = 0
	damage_mult = config.base_hit_damage_mult - config.high_hit_damage_mult*2

/obj/item/weapon/gun/energy/laspistol/reload_into_chamber(mob/user)			//To not listening for annoying *click*
	return 1

/obj/item/weapon/gun/energy/laspistol/update_icon()
	var/charge = (mag.charge * 100)/mag.maxcharge
	if(charge <= 100 && charge >= 75)
		icon_state = "energykill100"
		return
	if(charge < 75 && charge >= 50)
		icon_state = "energykill75"
		return
	if(charge < 50 && charge >= 25)
		icon_state = "energykill50"
		return
	if(charge < 25 && charge > 0)
		icon_state = "energykill25"
		return
	if(charge == 0)
		icon_state = "energykill0"
		return
	return

/obj/item/weapon/gun/energy/laspistol/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell/xba))
		var/obj/item/cell/C = A
		user.drop_held_item()
		visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [C.charge] power.")
		mag.loc = get_turf(user)
		mag = C
		C.loc = src
		playsound(src,'sound/machines/click.ogg', 25, 1)
		update_icon()
	else
		..()

/obj/item/weapon/gun/energy/laspistol/load_into_chamber()
	if(mag.charge - charge_cost < 0) return

	mag.charge -= charge_cost
	in_chamber = create_bullet(ammo)
	update_icon()
	return in_chamber