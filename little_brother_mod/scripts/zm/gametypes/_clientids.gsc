#insert scripts\shared\shared.gsh;

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\gametypes\_zm_lilbro_health;
#using scripts\zm\gametypes\_zm_lilbro_weapons;
#using scripts\zm\gametypes\_zm_lilbro_points;
#using scripts\zm\gametypes\_zm_lilbro_perks;

#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
	
function __init__() {
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawn );
}	

/**
Callback when a match starts
Waiting for the blackscreen to finish before loading all the options
If a second player is present, then we setup health, weapons, points and perks modifications
 */
function init() {
	// this is now handled in code ( not lan )
	// see s_nextScriptClientId 
	level.clientid = 0;

	//MOD START HERE!

	level flag::wait_till("initial_blackscreen_passed");
	IPrintLnBold("Welcome to Little Brother Mod");

	wait (3);
	
	players = getPlayers();
	if (players.size == 1) {
		IPrintLnBold("Only one player detected...");
		return;
	}

	//If player name contains " 1", then we give him extra health
	found_second_player = false;
	foreach (player in players) {
		if (IsSubStr(player.name, " 1")) {
			found_second_player = true;
			player player_health_setup();
			player player_weapons_setup();
			player player_points_setup();
			player player_perks_setup();
		}
	}

	if (!found_second_player) IPrintLnBold("No splitscreen player detected...");
}

/**
Callback when a player has connected
 */
function on_player_connect() {
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 ){
		self.clientid = level.clientid;
		level.clientid++;	// Is this safe? What if a server runs for a long time and many people join/leave
	}
}

/**
Callback when a player has spawned
 */
function on_player_spawn() {
}

/**
Calls module zm_lilbro_health and set the new maxHealth for self (aka player)
It even listens to max_health command to dynamically change the maxHealth
 */
function player_health_setup() {
	player = self;
	zm_lilbro_health::init();
	player thread zm_lilbro_health::set_lilbro_maxhealth();
	player thread zm_lilbro_health::listen_to_maxhealth_command();
}

/**
Calls module zm_lilbro_weapon and continously checks for un-upgraded weapon on player hands
It even listens to upgrade_weapons command to customize upgrading weapons process
 */
function player_weapons_setup() {
	player = self;
	zm_lilbro_weapons::init();
	player thread zm_lilbro_weapons::set_lilbro_upgraded_weapons();
	player thread zm_lilbro_weapons::listen_to_upgraded_weapons_command();
}

/**
	Listens to the points command using the zm_lilbro_points module
 */
function player_points_setup() {
	player = self;
	player thread zm_lilbro_points::listen_to_points_command();
}

/**
Calls module zm_lilbro_perks and adds default perks for player
It even listens to retain_perks command
 */
function player_perks_setup() {
	player = self;
	player zm_lilbro_perks::init();
	player thread zm_lilbro_perks::listen_to_retain_perks_command();
}


