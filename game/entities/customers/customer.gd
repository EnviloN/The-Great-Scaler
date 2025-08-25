class_name Customer
extends Resource


enum Customers {
	WIFE,
	PEASANT,
	BUTCHER,
	ELDER,
	KING,
}


@export var customer_name: Customers

@export_category("Visuals")
## Default visual variant for the customer.
@export var default_variant: CustomerVisualVariant
## Dictionary of additional visual variants for the customer.
@export var additional_variants: Dictionary[String, CustomerVisualVariant]

@export_category("Audio")
@export_group("Voice Lines")
## Array of voice lines for the customer.
@export var voices: Array[AudioStream]


func get_visuals(variant: String = "") -> CustomerVisualVariant:
	return additional_variants.get(variant, default_variant)
