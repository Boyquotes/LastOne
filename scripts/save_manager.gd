extends Node
class_name SaveManager

# TODO: add versioning to prevent double saving

func save_game(data: Dictionary):
    var save_game_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

    var json_string = JSON.stringify(data)
    save_game_file.store_pascal_string(json_string)
    save_game_file.close()


func load_game():
    if not FileAccess.file_exists("user://savegame.save"):
        return # Error! We don't have a save to load.

    var save_game_file = FileAccess.open("user://savegame.save", FileAccess.READ)
    var json_string = save_game_file.get_pascal_string()

    var parsed_gamestate = JSON.parse_string(json_string)

    if parsed_gamestate == null:
        return    

    save_game_file.close()

    return parsed_gamestate
