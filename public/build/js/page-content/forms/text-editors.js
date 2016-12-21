$(document).ready(function() {

    // Summernote
    // --------------------------------------------------

    $('#summernote-1').summernote({
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'hr']],
            ['view', ['fullscreen']]
        ]
    });

    $('#summernote-2').summernote({
        airMode: true
    });

});

var edit = function() {
    $('#summernote-3').summernote({
        focus: true,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'hr']],
            ['view', ['fullscreen']]
        ]
    });
};

var save = function() {
    var makrup = $('#summernote-3').summernote('code');
    $('#summernote-3').summernote('destroy');
};