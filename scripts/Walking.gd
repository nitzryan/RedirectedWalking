extends XRCamera3D

const curvature = 4
const curvatureGain = 90 / (curvature / 2 * PI)
const maxCurvature = 90 / (curvature / 2 * PI)
var lastPos = Vector3(0,0,0)
var centerPos = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	lastPos = self.position
	lastPos.y = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%Viewport2Din3D.rotation = %LeftController.global_rotation
	%Viewport2Din3D.position = %LeftController.global_position 
	%Viewport2Din3D.position += %LeftController.transform.basis.y * 0.2
	%Viewport2Din3D.position += %LeftController.transform.basis.x * -0.3
	

	#print(str(o.position))
	# Apply Curvature Gain
	# Amount user walked since last step
	var deltaPos = self.position - lastPos
	deltaPos.y = 0
	if deltaPos.length() > 0:
		lastPos = self.position
		lastPos.y = 0
		# Direction from user to center of room
		var toCenter = centerPos - self.position
		toCenter.y = 0
		
		# Determine vector to modify movement
		var anglePositive = (toCenter.x * deltaPos.z - toCenter.z * deltaPos.x) > 0
		var theta = atan2(toCenter.z, toCenter.x) - atan2(deltaPos.z, deltaPos.x)
		var costheta = (toCenter.dot(deltaPos)) / (toCenter.length() * deltaPos.length())
		#var costheta = cos(theta)
		var magnitudeCorrectionAngle = max(min(1 - costheta, 1), 0)
		var magnitudeCorrection = magnitudeCorrectionAngle * min(toCenter.length() / 1, 1)
		var rotAngle
		if anglePositive:
			#rotAngle = deltaPos.length() * curvatureGain * magnitudeCorrection
			rotAngle = maxCurvature * magnitudeCorrection
		else:
			#rotAngle = -deltaPos.length() * curvatureGain * magnitudeCorrection
			rotAngle = -maxCurvature * magnitudeCorrection
		var modifiedDelta = deltaPos.rotated(Vector3(0,1,0), rotAngle)
		var originMovement = modifiedDelta - deltaPos

		print("Theta: " + str(theta))
		print("Angle Positive: " + str(anglePositive))
		#print("Delta Pos: " + str(deltaPos))
		#print("To Center: " + str(toCenter))
		#print("Magnitude Correction: " + str(magnitudeCorrection))
		#print("Rotation Angle: " + str(rotAngle))
		#print("Modified Delta: " + str(modifiedDelta))
		#print("Origin Movement: " + str(originMovement))
		# Apply transform to XROrigin location/orientation
		# Perform rotation of XROrigin around the camera
		var orig = %XROrigin3D
		#orig.rotate(Vector3(0,1,0), -rotAngle * deltaPos.length() * PI / 180)
		orig.translate()
	return
