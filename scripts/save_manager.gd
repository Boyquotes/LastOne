extends Node

# TODO: add versioning to prevent double saving

func save_game():
    var save_game_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
    var serialized_gamestate = GameState.serialize()

    var json_string = JSON.stringify(serialized_gamestate)
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

    GameState.deserialize(parsed_gamestate)

    save_game_file.close()
