
$( window ).load(function() {
  $("#user_client_info_attributes_subject").select2();
});

// Mobile Menu

$('.mobile-toggle').click(function(){
  $('.nav-bar').toggleClass('nav-open');
  $(this).toggleClass('active');
});

$('.menu li').click(function(e){
  if (!e) e = window.event;
  e.stopPropagation();
  if($(this).find('ul').length){
    $(this).toggleClass('toggle-sub');
  }else{
    $(this).parents('.toggle-sub').removeClass('toggle-sub');
  }
});

$('.module.widget-handle').click(function(){
  $(this).toggleClass('toggle-widget-handle');
});


