extends CanvasLayer
@onready var ctrl = $Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func enable_passthrough() -> bool:
	var xr_interface: XRInterface = XRServer.primary_interface
	if xr_interface and xr_interface.is_passthrough_supported():
		if !xr_interface.start_passthrough():
			return false
	else:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
		else:
			return false

	get_viewport().transparent_bg = true
	return true

func _on_normal_btn_pressed():
	var xr_interface: XRInterface = XRServer.primary_interface
	xr_interface.stop_passthrough()
	
func _on_passthrough_btn_pressed():
	enable_passthrough()
