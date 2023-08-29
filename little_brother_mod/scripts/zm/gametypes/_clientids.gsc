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

function on_player_connect() {
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 ){
		self.clientid = level.clientid;
		level.clientid++;	// Is this safe? What if a server runs for a long time and many people join/leave
	}
}

function on_player_spawn() {
}

function player_health_setup() {
	player = self;
	zm_lilbro_health::init();
	player thread zm_lilbro_health::set_lilbro_maxhealth();
	player thread zm_lilbro_health::listen_to_maxhealth_command();
}

function player_weapons_setup() {
	player = self;
	zm_lilbro_weapons::init();
	player thread zm_lilbro_weapons::set_lilbro_upgraded_weapons();
	player thread zm_lilbro_weapons::listen_to_upgraded_weapons_command();
}

function player_points_setup() {
	player = self;
	player thread zm_lilbro_points::listen_to_points_command();
}

function player_perks_setup() {
	player = self;
	player zm_lilbro_perks::init();
	player thread zm_lilbro_perks::listen_to_retain_perks_command();
}


