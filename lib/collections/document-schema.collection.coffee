@DocumentSchema = 

	db: new Mongo.Collection('document-schema')

	MUTABLE_PROPERTIES: [
		'name'
		'description'
		'attributes'
	]

	ATTRIBUTE_DATA_TYPE:
		'Text':				{value: 100,		icon: 'fa-font'}
		'Content':			{value: 125,		icon: 'fa-paragraph'}
		'Number':			{value: 150,		icon: 'fa-calculator'}
		'Date':				{value: 200,		icon: 'fa-calendar'}
		'Duration':			{value: 225,		icon: 'fa-clock'}
		'Currency':			{value: 250,		icon: 'fa-dollar'}
		'Document':			{value: 300,		icon: 'fa-file-o'}
		'User':				{value: 350,		icon: 'fa-user'}
		'Image':			{value: 400,		icon: 'fa-image'}
		'Coordinates':		{value: 450,		icon: 'fa-map'}
		'Address':			{value: 500,	    icon: 'fa-home'}
		'Phone Number':		{value: 550,		icon: 'fa-phone'}
		'Email':			{value: 600,		icon: 'fa-at'}

	ATTRIBUTE_VALUE_TYPE:
		'Input':			{value: 100,		icon: 'fa-edit'}
		'Routine':			{value: 200,		icon: 'fa-gear'}

	new: ->
		'name': 					null
		'description':				null
		'attributes':				null
		'blueprint_id': 			null

	newAttribute: ->
		'name':						null
		'value_type':				null
		'input_type':				null
		'default_value':			null
		'routine_id':				null

	getNextAttributeId: (documentSchema) ->
		allIds = _.pluck(documentSchema.attributes, 'id')
		return 1 if _.isEmpty(allIds)
		highestId = _.first(allIds.sort((a,b) -> a < b))
		highestId++ 
		return highestId

	attributeHasDefaultValue: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentSchema.ATTRIBUTE_VALUE_TYPE['Input'].value
		return false

	attributeHasRoutineId: (attribute) ->
		return false unless attribute?
		return true if attribute['value_type'] is DocumentSchema.ATTRIBUTE_VALUE_TYPE['Routine'].value
		return false
