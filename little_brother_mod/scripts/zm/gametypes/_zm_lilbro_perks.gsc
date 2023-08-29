#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_perks;

#namespace zm_lilbro_perks; 

#define LILBRO_PERK_LIMIT 31

function init() {
	player = self;
	
	//zm_utility::get_player_perk_purchase_limit checks if there's someone overriding it on level
	//If so, it uses its implementation, we use it to change perk limit
	//This variable is created and set only for the little bro
	
	player.perk_limit = LILBRO_PERK_LIMIT;
	level.get_player_perk_purchase_limit = &get_perk_limit;

	zm_perks::vending_trigger_post_think(player, "specialty_armorvest");
	zm_perks::vending_trigger_post_think(player, "specialty_fastreload");
	zm_perks::vending_trigger_post_think(player, "specialty_staminup");

}

function get_perk_limit() {
	player = self;
	if (IsDefined(player.perk_limit)) return player.perk_limit;
	else return level.perk_purchase_limit;
}

function listen_to_retain_perks_command() {
	player = self;
	player endon("disconnect");
	
	player._retain_perks = true;
	ModVar("lil_bro_retain_perks", 1);
	
	while(1) {
		WAIT_SERVER_FRAME
		dvar_value = GetDvarInt("lil_bro_retain_perks", 1);
		if((dvar_value >= 1 && player._retain_perks == false) ||
			dvar_value <= 0 && player._retain_perks == true){
			
			player._retain_perks = !player._retain_perks;
			if (player._retain_perks) {
				IPrintLnBold(player.name + " will retain perks when going down");
			} else {
				IPrintLnBold(player.name + " won't retain perks when going down");
			}
		}
	}
}

/**
* Changes movement aspects more deeply
function set_lilbro_movement_speed_modifier() {
	player = self;
	player endon("disconnect");
	
	IPrintLnBold(player.name + " current movement speed scale is: " + player GetMoveSpeedScale());
	while(1) {
		player SetMoveSpeedScale( DEFAULT_SPEED_SCALE );
		player SetSprintDuration( DEFAULT_SPRINT_DURATION );
		player SetSprintCooldown( DEFAULT_SPRINT_COOLDOWN );
		while(DEFAULT_SPEED_SCALE == player GetMoveSpeedScale()) WAIT_SERVER_FRAME;
		IPrintLnBold(player.name + " current movement speed scale is: " + player GetMoveSpeedScale());

	}
}
*/