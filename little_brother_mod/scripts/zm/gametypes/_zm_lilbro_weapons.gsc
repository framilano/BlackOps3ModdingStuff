#insert scripts\shared\shared.gsh;
#insert scripts\shared\aat_zm.gsh;

#using scripts\zm\_zm_weapons;
#using scripts\shared\aat_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_lilbro_weapons; 

#define DEFAULT_SHOULD_UPGRADE_WEAPONS 0
#define DEFAULT_SHOULD_PUT_AAT 0


function init() {
	level.lil_bro_upgraded_weapons = DEFAULT_SHOULD_UPGRADE_WEAPONS;
	level.lil_bro_upgraded_weapons_aat = DEFAULT_SHOULD_PUT_AAT;
}

/**
* Switch to a new weapon
*/
function switch_to_weapon(player, current_weapon, new_weapon, should_refill, should_put_pap_camo) {
	new_weapon.camo_index = player zm_weapons::get_pack_a_punch_weapon_options( new_weapon );

	player TakeWeapon(current_weapon);
    
	if (isDefined(should_put_pap_camo) && IS_TRUE(should_put_pap_camo)) {
		player GiveWeapon(new_weapon, new_weapon.camo_index);
	}
	
	if (isDefined(should_refill) && IS_TRUE(should_refill)) {
		self GiveMaxAmmo(new_weapon);
	}
	
	player SwitchToWeapon(new_weapon);

	//zm_utility::play_sound_at_pos( "zmb_perks_packa_ready", player );
}

/**
* Continuously checks if the user has a weapon to upgrade
*/
function set_lilbro_upgraded_weapons() {
	player = self;
	player endon("disconnect");
	
	while(1) {
		WAIT_SERVER_FRAME
		current_weapon = player GetCurrentWeapon();
		
		//Weapon isn't upgraded, it can be upgraded and the user requested it to be upgraded
		if (!zm_weapons::is_weapon_upgraded(current_weapon) && 
			zm_weapons::can_upgrade_weapon(current_weapon) && 
			IS_TRUE(level.lil_bro_upgraded_weapons)) {
			
			upgraded_weapon = zm_weapons::get_upgrade_weapon(current_weapon, false);
			//Removes AAT if they have been acquired before for this specific weapon
			player thread aat::remove(upgraded_weapon);

			//User requested to apply AAT effects on the weapon
			if (zm_weapons::weapon_supports_aat(upgraded_weapon) && IS_TRUE(level.lil_bro_upgraded_weapons_aat)) {
				player thread aat::acquire(upgraded_weapon);
			}
			
			switch_to_weapon(player, current_weapon, upgraded_weapon, true, true);
		}
	}
}

/**
* Continously checks new input on lil_bro_upgraded_weapons command
* Upgrades vars accordingly to command parameters
*/
function listen_to_upgraded_weapons_command() {
	player = self;
	player endon("disconnect");
	
	ModVar("lil_bro_upgraded_weapons", DEFAULT_SHOULD_UPGRADE_WEAPONS + " " + DEFAULT_SHOULD_PUT_AAT);
	while(1) {
		WAIT_SERVER_FRAME
		dvar_value = GetDvarString("lil_bro_upgraded_weapons", DEFAULT_SHOULD_UPGRADE_WEAPONS + " " + DEFAULT_SHOULD_PUT_AAT);

		//Retrieving values for this command
		upgrade_dvar = StrTok(dvar_value, " ")[0];
		aat_dvar = StrTok(dvar_value, " ")[1];

		//Checking user inserted values
		if ((upgrade_dvar != "0" && upgrade_dvar != "1") || (aat_dvar != "0" && aat_dvar != "1")) {
			IPrintLnBold("Invalid values for lil_bro_upgraded_weapons!");
			continue;
		}

		if (upgrade_dvar == "0" && aat_dvar == "1") {
			IPrintLnBold("Invalid combination for lil_bro_upgraded_weapons!");
			continue;
		}


		//Detecting if vars have changed
		if (Int(upgrade_dvar) != level.lil_bro_upgraded_weapons || 
			Int(aat_dvar) != level.lil_bro_upgraded_weapons_aat) {
			
			level.lil_bro_upgraded_weapons = Int(upgrade_dvar);
			level.lil_bro_upgraded_weapons_aat = Int(aat_dvar);
			
			if (level.lil_bro_upgraded_weapons == 0) {
				IPrintLnBold("From now on " + player.name + " weapons won't be automatically pack-a-punched");
			} else {
				IPrintLnBold("From now on " +player.name + " weapons will be automatically pack-a-punched");
				if (IS_TRUE(level.lil_bro_upgraded_weapons_aat))
					IPrintLnBold("From now on " +player.name + " weapons will automatically have AAT on them");
				else {
					IPrintLnBold("From now on " +player.name + " weapons won't automatically have AAT on them");
				}
			}
		}

	}
}