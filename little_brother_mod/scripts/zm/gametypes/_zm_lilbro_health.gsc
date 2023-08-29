#insert scripts\shared\shared.gsh;

#namespace zm_lilbro_health; 

#define DEFAULT_LIL_BRO_MAX_HEALTH 300

function init() {
	level.lil_bro_maxhealth = DEFAULT_LIL_BRO_MAX_HEALTH;
}

function set_lilbro_maxhealth() {
	player = self;
	player endon("disconnect");
	
	IPrintLnBold(player.name + " current max health is: " + level.lil_bro_maxhealth);
	while(1) {
		player SetMaxHealth(level.lil_bro_maxhealth);
		while(player.maxHealth == level.lil_bro_maxhealth) WAIT_SERVER_FRAME;
	}
}

function listen_to_maxhealth_command() {
	player = self;
	player endon("disconnect");
	
	ModVar("lil_bro_maxhealth", level.lil_bro_maxhealth);
	while(1) {
		WAIT_SERVER_FRAME
		dvar_value = GetDvarInt("lil_bro_maxhealth", DEFAULT_LIL_BRO_MAX_HEALTH);
		if(dvar_value != level.lil_bro_maxhealth){
			level.lil_bro_maxhealth = dvar_value;
			IPrintLnBold(player.name + " current max health is: " + level.lil_bro_maxhealth);
		}
	}
}