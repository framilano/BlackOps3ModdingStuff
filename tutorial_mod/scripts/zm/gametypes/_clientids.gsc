#insert scripts\shared\shared.gsh;

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\ai_shared;
//#using scripts\zm\gametypes\_zm_commands;


#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
	
function __init__() {
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawn );
}	

function init() {
	// this is now handled in code ( not lan )
	// see s_nextScriptClientId 
	level.clientid = 0;
}

function on_player_connect() {
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 )
	{
		self.clientid = level.clientid;
		level.clientid++;	// Is this safe? What if a server runs for a long time and many people join/leave
	}

}

function set_player_max_health(player) {
	for (;;) {
		IPrintLnBold("Player Max Health: " + player.maxHealth);
		player SetMaxHealth(400);
		while(player.maxHealth == 400) wait(1);
	}
}

function on_player_spawn() {
	level flag::wait_till("initial_blackscreen_passed");
	IPrintLnBold("Hello, welcome to my mod!");

	players = getPlayers();
	if (players.size == 1) {
		IPrintLnBold("Only one player detected...");
		return;
	}


	//If player name contains _1, then we give him extra health
	foreach (player in players) {
		if (IsSubStr(player.name, "_1")) thread set_player_max_health(players[1]);
	}
	
	IPrintLnBold("Now Zombies ignore you");
	//self ai::set_ignoreme( true );

	IPrintLnBold("You're now invincible");
	//self EnableInvulnerability();

	//self thread zm_commands::wait_for_points_command();
}
