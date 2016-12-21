'use strict';

$(document).ready(function() {

    // Element Blocking
    // --------------------------------------------------

    function blockUI(element) {
        $(element).block({
            message: '<div class=\'sk-double-bounce\'><div class=\'sk-child sk-double-bounce1\'></div><div class=\'sk-child sk-double-bounce2\'></div></div>',
            css: {
                border: 'none',
                backgroundColor: 'transparent'
            },
            overlayCSS: {
                backgroundColor: '#FAFEFF',
                opacity: 0.5,
                cursor: 'wait'
            }
        });
    }

    function unblockUI(element) {
        $(element).unblock();
    }

    // Toggle Sidebar
    // --------------------------------------------------

    $('.sidebar-control').on('click', function() {
        $('body').toggleClass('sidebar-unpin');
    });

    $('.hamburger-menu').on('click', function() {
        $(this).toggleClass('active');
        $('body').toggleClass('main-sidebar-toggled');
    });

    // Extra Sidebars
    // --------------------------------------------------

    $('.sidebar-toggle').on('click', function() {
        $('body').toggleClass('sidebar-toggled');
    });

    // Toogle Searchbar
    // --------------------------------------------------

    $('.search-bar-toggle').on('click', function() {
        $('.search-bar').toggleClass('closed');
    });

    // Toggle Right Sidebar
    // --------------------------------------------------

    $('.right-sidebar-toggle').on('click', function() {
        $('.right-sidebar').toggleClass('closed');
    });

    // Toggle Conversation Sidebar
    // --------------------------------------------------

    $('.conversation-toggle').on('click', function() {
        $('.conversation').toggleClass('closed');
    });

    // Tooltips & Popovers
    // --------------------------------------------------

    $('[data-toggle=\'tooltip\']').tooltip();
    $('[data-toggle=\'popover\']').popover();

    // Widget Controls
    // --------------------------------------------------

    $('.widget-collapse').on('click', function() {
        $(this).closest('.widget').find('.widget-body').slideToggle(300);
        $(this).find('i').toggleClass('ion-chevron-up ion-chevron-down');
    });
    $('.widget-reload').on('click', function() {
        var element = $(this).closest('.widget');
        blockUI(element);
        window.setTimeout(function() {
            unblockUI(element);
        }, 3000);
    });
    $('.widget-remove').on('click', function() {
        $(this).closest('.widget').hide();
    });

    // Progressbar
    // --------------------------------------------------

    if ($('.progress').length > 0) {
        $('.progress .progress-bar').progressbar();
    }

    // Managing CSS animations
    // --------------------------------------------------

    $('.animated').animo({
        duration: 0.2
    });

});