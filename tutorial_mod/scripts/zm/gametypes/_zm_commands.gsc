#using scripts\zm\_zm_score;

#namespace zm_commands;

function wait_for_points_command() {
	self endon("disconnect");

	ModVar("points", "");
	
	while(1) {
		WAIT_SERVER_FRAME
		ModVar("points", "");
		dvar_value = ToLower(GetDvarString("points", ""));
		self zm_score::add_to_player_score( dvar_value );
	}
}