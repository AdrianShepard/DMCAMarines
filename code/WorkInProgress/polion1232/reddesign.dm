#define MARINE_PROTHOLATHE 1

/datum/marine_design
	var/name = ""		//Design Name
	var/desc = ""		//Design Description
	var/id = null		//Desighn ID
	var/build_path = null			//Base of the Design
	var/build_type		//In what kind of machine it will be built
	var/list/req_tech = list()		//What needed for design
	var/list/materials = list()		//Needed materials

///// Machines of xenos' impending DOOM /////

/datum/marine_design/anti_weed
	name = "Plant-B-Gone military-grade sprinkler"
	desc = "Common pesticide had been found useful against Xenoflora of all kind."
	id = "sprayer"
	build_path = /obj/item/reagent_container/spray/anti_weed
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_FLORA)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 0)

/datum/marine_design/anti_acid
	name = "Anti-Acid standart chemical mixture"
	desc = "Useful mixture of alkalies, strong enough to neutralize most of XBA-based acids."
	id = "anti-acid_sprayer"
	build_path = /obj/item/anti_acid
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_SPITTER)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 0)

/datum/marine_design/biocircuit
	name = "Biogenerator Prototype"
	desc = "With understanding Hivelord's metabolism we can potentially have infinite source of Xenomorph biomaterial"
	id = "hivethingy"
	build_path = /obj/item/circuitboard/machine/biolathe
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_HIVELORD)
	materials = list("metal" = 0, "glass" = 500, "biomass" = 50)

/datum/marine_design/teslagun
	name = "HEW \"Paralayzer\" military-grade retrofit"
	desc = "Initial flaw, that we found in Xenomorph organism, bring us to the idea of retrofitting old Heavy Electrical Weapon. But it need suitable recharger, what can be created separately."
	id = "tesla"
	build_path = /obj/item/weapon/gun/energy/tesla
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENOSTART)
	materials = list("metal" = 1000, "glass" = 500, "biomass" = 0)

/datum/marine_design/teslabackpack
	name = "HEW-2 \"Zeus\" Powerpack"
	desc = "Powerful recharging system for HEW-2 \"Zeus\", needed for proper functioning of discharger."
	id = "teslabackpack"
	build_path = /obj/item/tesla_powerpack
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENOSTART)
	materials = list("metal" = 1000, "glass" = 500, "biomass" = 0)

/datum/marine_design/cell
	name = "XBA-based power cells"
	desc = "Powerful Xenomoprh acids can be very useful for power cells' production."
	id = "cell"
	build_path = /obj/item/cell/xba
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_CHEMISTRY)
	materials = list("metal" = 100, "glass" = 0, "biomass" = 100)