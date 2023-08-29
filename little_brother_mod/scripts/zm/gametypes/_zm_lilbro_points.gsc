#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_score;

#namespace zm_lilbro_points; 

function listen_to_points_command() {
	player = self;
	player endon("disconnect");
	
	ModVar("lil_bro_points", 0);
	while(1) {
		WAIT_SERVER_FRAME
		dvar_value = GetDvarInt("lil_bro_points", 0);
        ModVar("lil_bro_points", 0);
		if(dvar_value != 0){
			player zm_score::add_to_player_score(dvar_value);
			IPrintLnBold("Added " + dvar_value + " points to "+ player.name);
		}
	}
}