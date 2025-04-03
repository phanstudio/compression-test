extends Node
class_name SaveLoader

const SAVE_DIR = "user://token/"
static var save_path = SAVE_DIR + "token.dat"

static func save_with_key(key, value) -> void:
	if !DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, key)
	var error = FileAccess.get_open_error()
	if error == OK:
		file.store_var(value)
		file.close()

static func load_with_key(key) -> Variant:
	if FileAccess.file_exists(save_path):
		var file = decrypt(save_path, key)
		var error = FileAccess.get_open_error()
		if error == OK:
			var value = file.get_var()
			file.close()
			return value
	return null

static func decrypt(path, key) -> FileAccess:
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, key)
	return file

static func save_file(value, file_path) -> void:
	#if !DirAccess.dir_exists_absolute(SAVE_DIR):
		#DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	if error == OK:
		file.store_var(value)
		file.close()

static func load_file(file_path) -> Variant:
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var error = FileAccess.get_open_error()
		if error == OK:
			var value = file.get_var()
			file.close()
			return value
	return null
