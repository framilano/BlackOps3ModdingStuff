import json
import os
import msvcrt


def load_config():
    with open("config.json", "r") as f:
        config = json.load(f)
        return config


def main():
    config = load_config()
    common_path = config["steam_common_path"]

    list_of_folders = os.listdir(common_path)
    current_bo3_folder = common_path + "\\Call of Duty Black Ops III"
    enhanced_folder = common_path + "\\Call of Duty Black Ops III [Enhanced]"
    modtool_folder = common_path + "\\Call of Duty Black Ops III [ModTool]"
    
    mode = ""

    if ("Call of Duty Black Ops III [ModTool]" in list_of_folders):
        os.rename(current_bo3_folder, enhanced_folder)
        os.rename(modtool_folder, current_bo3_folder)
        print("Switched to BO3 Mod Tool.")
        mode = "bo3modtool"
    elif ("Call of Duty Black Ops III [Enhanced]" in list_of_folders):
        os.rename(current_bo3_folder, modtool_folder)
        os.rename(enhanced_folder, current_bo3_folder)
        print("Switched to Enhanced BO3.")
        mode = "bo3enhanced"
    else:
        print("BO3 not found, check your steam_common_path in config.json")

    print("Launch it? y/N")
    answer = msvcrt.getch().strip().lower()
    if (answer == b'y' or answer == b''):
        if (mode == "bo3enhanced"): os.system("\"C:\\Program Files (x86)\\Steam\\steam.exe\" steam://rungameid/311210")
        else: os.system("\"C:\\Program Files (x86)\\Steam\\steam.exe\" steam://rungameid/455130")


if (__name__ == "__main__"): main()