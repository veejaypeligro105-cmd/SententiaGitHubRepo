extends Resource

class_name EnemyData

@export var sprite_2d_frames: SpriteFrames
@export var anim_prefix: String

@export var enemy_id: String
@export var enemy_name: String
@export var max_hp: int = 100
@export var base_damage: int = 10
#Classification of enemy

@export_enum("Normal", "MiniBoss", "Boss") var enemy_type: String = "Normal"

#New Rewards
@export var xp_reward: int = 10
@export var gold_reward: int = 5

#Optional drops(Can drag items here in inspector)
@export var item_drop: Array[ItemData] = []

#@export_enum("Floor1", "Floor2","TruthTables","LogicalEquivalence") var question_pool_id: String = "Floor1"d
