extends Node

const POOL_PATHS := {
	"Floor1": "res://QUESTIONFILE/floor1_cases.tres",
	"Floor2": "res://QUESTIONFILE/floor2_cases.tres",
	"TruthTables": "",
	"LogicalEquivalence": "",
}

func get_pool(pool_id: String) -> Array[QuestionData]:
	if not POOL_PATHS.has(pool_id):
		push_error("CashDatabase: no pool registered for id '%s' " % pool_id)
		return []
	var pool_resource: QuestionPool = load(POOL_PATHS[pool_id])
	if pool_resource == null:
		push_error("CaseDataBase: failed to load pool at '%s'" % POOL_PATHS[pool_id])
		return[]
	return pool_resource.cases
