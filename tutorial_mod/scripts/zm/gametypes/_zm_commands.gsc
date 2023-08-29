#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_score;

#namespace zm_commands;

function wait_for_points_command(players) {
	self endon("disconnect");
	
	ModVar("points", 0);
	while(1) {
		WAIT_SERVER_FRAME;
		dvar_value = GetDvarInt("points", 0);
		if(dvar_value != 0){
			ModVar("points", 0); //Resetting value for next time
			IPrintLnBold("Added " + dvar_value +" points to score");
			foreach(player in players) {
				player zm_score::add_to_player_score( dvar_value );
			}
		}
	}
}