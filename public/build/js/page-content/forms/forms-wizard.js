$(document).ready(function() {
	$('#form-horizontal').steps({
		headerTag: 'h3',
		bodyTag: 'fieldset',
		transitionEffect: 'slide'
	});
	$('#form-tabs').steps({
		headerTag: 'h3',
		bodyTag: 'fieldset',
		transitionEffect: 'slideLeft',
		enableFinishButton: false,
		enablePagination: false,
		enableAllSteps: true,
		titleTemplate: '#title#',
		cssClass: 'tabcontrol'
	});
});
