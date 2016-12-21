$(document).ready(function() {
    $('#basic-owl-carousel').owlCarousel({
        loop: true,
        autoplayHoverPause: true,
        margin: 10,
        nav: true,
        autoplay: true,
        autoplayTimeout: 3000,
        responsive: {
            0: {
                items: 1
            },
            768: {
                items: 2
            },
            992: {
                items: 3
            },
            1200: {
                items: 3
            }
        }
    });

    $('#rtl-owl-carousel').owlCarousel({
        loop: true,
        rtl: true,
        autoplayHoverPause: true,
        margin: 10,
        nav: true,
        autoplay: true,
        autoplayTimeout: 3000,
        responsive: {
            0: {
                items: 1
            },
            768: {
                items: 2
            },
            992: {
                items: 3
            },
            1200: {
                items: 3
            }
        }
    });

    $('#animate-owl-carousel').owlCarousel({
        animateOut: 'rollOut',
        animateIn: 'rollIn',
        items: 1,
        loop: true,
        autoplayHoverPause: true,
        autoplay: true,
        autoplayTimeout: 3000
    });

    $('#retina-owl-carousel').owlCarousel({
        lazyLoad: true,
        items: 1,
        loop: true,
        autoplayHoverPause: true,
        autoplay: true,
        autoplayTimeout: 3000
    });

});