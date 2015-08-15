Meteor.methods
	'Document.create': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "document_schema_id" is required') if _.isEmpty(parameters['document_schema_id'])
		throw new Error('Parameter "environment_id" is required') if _.isEmpty(parameters['environment_id'])

		document_schema = DocumentSchema.db.findOne(parameters['document_schema_id'])
		throw new Error('Cannot find DocumentSchema for new Document') unless document_schema?

		environment = Environment.db.findOne(parameters['environment_id'])
		throw new Error('Cannot find Environment for new Document') unless environment?

		document = Document.new(parameters)
		document['size'] = JSON.stringify(document).length

		Document.validate(document, document_schema)
		throw new Meteor.Error('limits', 'Application database limit reached') unless Meteor.call('Limits.canCreateDocument', environment['application_id'], document)

		document['_id'] = Document.db.insert(document)

		Application.updateDbSize(environment['application_id'])

		return document['_id']

	'Document.update': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?

		document = Document.db.findOne(parameters['_id'])
		throw new Error('Cannot find Document') unless document?

		document_schema = DocumentSchema.db.findOne(document['document_schema_id'])
		throw new Error('Cannot find DocumentSchema for new Document') unless document_schema?

		environment = Environment.db.findOne(document['environment_id'])
		throw new Error('Cannot find Environment for Document') unless environment?

		updates = _.pick(parameters, Document.MUTABLE_PROPERTIES)

		Document.validate(updates, document_schema)
		throw new Meteor.Error('limits', 'Application database limit reached') unless Meteor.call('Limits.canUpdateDocument', environment['application_id'], document, updates)

		_.assign(document, updates)
		updates['size'] = JSON.stringify(document).length

		Document.db.update({'_id': document['_id']}, {$set: updates})

		Application.updateDbSize(environment['application_id'])

		return document['_id']

	'Document.updateAttributes': (parameters) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Parameters object is required') unless parameters?
		throw new Error('Parameter "document_id" is required') if _.isEmpty(parameters['document_id'])
		throw new Error('Parameter "attributes" is required') if _.isEmpty(parameters['attributes'])
		throw new Error('Parameter "attributes" is invalid') unless _.isArray(parameters['attributes'])

		document = Document.db.findOne(parameters['document_id'])
		throw new Error('Cannot find Document') unless document?

		document_schema = DocumentSchema.db.findOne(document['document_schema_id'])
		throw new Error('Cannot find DocumentSchema for new Document') unless document_schema?

		environment = Environment.db.findOne(document['environment_id'])
		throw new Error('Cannot find Environment for Document') unless environment?

		updates = {'data': {}}
		parameters['attributes'].forEach (attribute) ->
			return unless document['data'].hasOwnProperty(attribute['id'])
			updates['data'][attribute.id] = attribute['value']

		Document.validate(updates, document_schema)
		throw new Meteor.Error('limits', 'Application database limit reached') unless Meteor.call('Limits.canUpdateDocument', environment['application_id'], document, updates)

		_.assign(document, updates)
		updates['size'] = JSON.stringify(document).length

		Document.db.update({'_id': document['_id']}, {$set: updates})

		Application.updateDbSize(environment['application_id'])

		return document['_id']

	'Document.delete': (id) ->
		throw new Error('Unauthorized') unless Meteor.user()?
		throw new Error('Id is required') if _.isEmpty(id) and _.isString(id)

		document = Document.db.findOne(id)
		throw new Error('Cannot find Document') unless document?

		environment = Environment.db.findOne(document['environment_id'])
		throw new Error('Cannot find Environment for Document') unless environment?

		Document.db.remove(document['_id'])

		Application.updateDbSize(environment['application_id'])

		return
