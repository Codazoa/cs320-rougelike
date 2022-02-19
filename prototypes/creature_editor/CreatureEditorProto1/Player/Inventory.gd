extends Resource
class_name Inventory

signal inventory_changed

export var _features = Array() setget set_features, get_features


func set_features(new_features):
	_features = new_features
	emit_signal("inventory_changed", self)

func get_features():
	return _features

func get_feature(index):
	return _features[index]

func add_feature(feature_name, quantity):
	if quantity <= 0:
		print("Can't add a negative num of features")
		return
		
	var feature = FeatureDatabase.get_feature(feature_name)
	if not feature:
		print("Could not find feature")
		return
	
	# Flag to determine if feature has been stacked
	var no_stack = 1;
	var max_stack_size = 100 if feature.stackable else 1
	
	for i in range(_features.size()):
		# If index in feature list does not equal feature in database, skip
		if _features[i].feature_reference.name != feature.name:
			continue
			
		# Otherwise we found index of feature
		# Add the quantity, if over 100 or 1, just make 100 or 1
		if _features[i].quantity < max_stack_size:
			_features[i].quantity = \
				min(_features[i].quantity + quantity, max_stack_size)
			no_stack = 0;
			break
	
	# If feature wasn't already present in inventory (feature  now unlocked)
	if no_stack == 1:
		var new_feature = {
			# TO-DO: Is there a better way to reference this?
			feature_reference = feature,
			quantity = min(quantity, max_stack_size)
		}
		
		_features.append(new_feature)
		
	emit_signal("inventory_changed", self)
