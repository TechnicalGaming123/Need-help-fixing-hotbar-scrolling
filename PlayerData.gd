extends Node

const maxhealth = 10
const maxenergy = 100



var health : float = 10
var energy : float = 100

func takeHealth(hitpoints):
	health = clamp(health - hitpoints, 0, maxhealth)
	
func takeEnergy(energyPoints):
	energy = clamp(energy - energyPoints, 0, maxenergy)
	
func updateUI(ui1, ui2):
	ui1.rect_scale.x = health / maxhealth
	ui2.rect_scale.x = energy / maxenergy

