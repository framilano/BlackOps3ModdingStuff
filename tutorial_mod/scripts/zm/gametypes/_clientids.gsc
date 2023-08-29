#insert scripts\shared\shared.gsh;

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\ai_shared;
#using scripts\zm\gametypes\_zm_commands;
#using scripts\zm\_zm_score;

#using scripts\zm\_zm_perks;


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

function retrieve_all_perks() {
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	perks = [];
	foreach (trigger in vending_triggers) {
		perk = trigger.script_noteworthy;
		perks[perks.size] = perk;
	}
	return perks;
}

function on_player_spawn() {
	level flag::wait_till("initial_blackscreen_passed");
	IPrintLnBold("Hello, welcome to my mod!");

	players = getPlayers();
	
	//IPrintLnBold("Now Zombies ignore you");
	//self ai::set_ignoreme( true );

	//IPrintLnBold("You're now invincible");
	//self EnableInvulnerability();

	//perks = retrieve_all_perks();
	//IPrintLnBold("There are " + perks.size +" perks in this map");

	wait(5);
	foreach(player in players) {
		zm_perks::vending_trigger_post_think(player, "specialty_armorvest");
		wait(10);
		player giveWeapon(GetWeapon("ray_gun"));
		player zm_score::add_to_player_score( 99999 );
	}

	thread zm_commands::wait_for_points_command(players);
}
