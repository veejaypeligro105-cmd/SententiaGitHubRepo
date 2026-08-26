extends Node

var Skills:Array = []
var Cooldowns:Array = []

signal AttackSig

func Attack(skill):
	var index = Skills.find(skill)
	
	if index == -1:
		print("Skill not found!")
		return

	if Cooldowns[index] != 0:
		print("Skill on cooldown!")
		return

	var Targets = get_parent().CurrentTargets
	var Damage = CalculateDamage(skill)

	for target in Targets:
		if target == null or not is_instance_valid(target):
			continue
		target.RecievedDamage(Damage, skill.SkillType)

	RefreshCooldowns()
	Cooldowns[index] = skill.SkillCooldown

	AttackSig.emit()

func MobAttack():
	if randi_range(0,1) == 1 and Cooldowns[1] == 0:
		Attack(Skills[1])
	else:
		Attack(Skills[0])

func CalculateDamage(skill):
	var stat_value := 0
	match skill.SkillType:
		"Str":
			stat_value = get_parent().Str
		"Dex":
			stat_value = get_parent().Dex
		"Int":
			stat_value = get_parent().Int

	var damage = stat_value * (skill.SkillPower / 100.0)
	return damage

func LoadSkills(skills):
	for skill in skills:
		Skills.append(skill)
		Cooldowns.append(skill.SkillCooldown)

func RefreshCooldowns():
	for i in range(len(Cooldowns)):
		Cooldowns[i] = max(Cooldowns[i] -1,0)
