if (typeof CKEDITOR != "undefined") {
  CKEDITOR.disableAutoInline = true;

  CKEDITOR.editorConfig = function( config ) {
    config.filebrowserBrowseUrl           = "/ckeditor/attachment_files"
    config.filebrowserFlashBrowseUrl      = "/ckeditor/attachment_files"
    config.filebrowserFlashUploadUrl      = "/ckeditor/attachment_files"
    config.filebrowserImageBrowseLinkUrl  = "/ckeditor/pictures"
    config.filebrowserImageBrowseUrl      = "/ckeditor/pictures"
    config.filebrowserImageUploadUrl      = "/ckeditor/pictures"
    config.filebrowserUploadUrl           = "/ckeditor/attachment_files"
  };
};
