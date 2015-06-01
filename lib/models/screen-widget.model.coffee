@ScreenWidget =

	TYPE:
		'Container':
			value: 100
			component: 'container'
			icon: 'fa-th-large'
			configuration:
				'layout': null

		'Table':
			value: 150
			component: 'table'
			icon: 'fa-table'
			configuration:
				'show_edit_buttons': true
				'show_select_button': false
				'data_source':
					'type': null
					'document_schema_id': null

		'List':
			value: 200
			component: 'list'
			icon: 'fa-th-list'
			configuration:
				'data_source':
					'type': null
					'document_schema_id': null

		'Content':
			value: 250
			component: 'content'
			icon: 'fa-paragraph' 
			configuration:
				'content_html': null

		'Screen':
			value: 300
			component: 'screen'
			icon: 'fa-list-alt'
			configuration:
				'screen_schema_id': null

		'Button':
			value: 350
			component: 'button'
			icon: 'fa-caret-square-o-right'
			configuration:
				'routine_id': null

	CONTAINER_LAYOUT:
		'Vertical': 	{value: 100}
		'Horizontal': 	{value: 200}

	DATA_SOURCE_TYPE:
		'Document':		{value: 100}

	new: (parameters) ->
		type = _.findWhere(ScreenWidget.TYPE, 'value': parameters['type'])
		throw new Error('Unrecognized ScreenWidget.TYPE specified') unless type?

		result =
			'id':				Meteor.uuid()
			'name':				parameters['name']
			'type':				type['value']
			'configuration':	_.clone(type['configuration'])
			'parent_id':		null
			'child_ids':		[]
		
		switch type
			when ScreenWidget.TYPE['Container']
				result['configuration']['layout'] = ScreenWidget.CONTAINER_LAYOUT['Vertical'].value

		return result