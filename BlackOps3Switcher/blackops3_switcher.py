import json
from subprocess import Popen
from os import listdir, rename
from msvcrt import getch

def load_config():
    with open("config.json", "r") as f:
        config = json.load(f)
        return config

config = load_config()

def rename_to_correct_folder(mode):
    common_path = config["steam_common_path"]

    list_of_folders = listdir(common_path)
    current_bo3_folder = common_path + "\\Call of Duty Black Ops III"
    enhanced_folder = common_path + "\\Call of Duty Black Ops III [Enhanced]"
    modtool_folder = common_path + "\\Call of Duty Black Ops III [ModTool]"
    
    if ("Call of Duty Black Ops III [ModTool]" in list_of_folders and mode == "bo3modtool"):
        rename(current_bo3_folder, enhanced_folder)
        rename(modtool_folder, current_bo3_folder)
        print("Renamed to BO3 Mod Tool.")
    elif ("Call of Duty Black Ops III [Enhanced]" in list_of_folders and mode == "bo3enhanced"):
        rename(current_bo3_folder, modtool_folder)
        rename(enhanced_folder, current_bo3_folder)
        print("Renamed to Enhanced BO3.")
    elif ("Call of Duty Black Ops III [ModTool]" in list_of_folders and mode == "bo3enhanced"): print("Starting Enhanced BO3.")
    elif ("Call of Duty Black Ops III [Enhanced]" in list_of_folders and mode == "bo3modtool"): print("Starting BO3 Mod Tool.")
    else: print("BO3 not found, check your steam_common_path in config.json")

def main():
    print("Wanna launch BO3 (E)nhanced or BO3 (M)od Tool?")

    answer = getch().strip().lower()

    if (answer == b'e'):
        rename_to_correct_folder("bo3enhanced")
        Popen("C:\\Program Files (x86)\\Steam\\steam.exe steam://rungameid/311210".split(" "))
    elif (answer == b'm'):
        rename_to_correct_folder("bo3modtool")
        Popen("C:\\Program Files (x86)\\Steam\\steam.exe steam://rungameid/455130".split(" "))



if (__name__ == "__main__"): main()