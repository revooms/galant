extends EditorPlugin
class_name GalantEditorPlugin

func _enable_plugin():
	var path = self.get_script().resource_path
	var name = path.split("/")[-2].split(".")[1]
	var autoload = "%s/autoload/%s.gd" % [path.replace("/plugin.gd", "") , name]
	print("GalantEditorPlugin: Registering autoload %s as %s" % [autoload, name])
	add_autoload_singleton(name, autoload)

func _disable_plugin():
	var path = self.get_script().resource_path
	var name = path.split("/")[-2].split(".")[1]
	print("GalantEditorPlugin: Unregistering autoload %s" % [name])
	remove_autoload_singleton(name)

