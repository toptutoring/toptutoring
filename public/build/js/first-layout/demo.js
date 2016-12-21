'use strict';

$(document).ready(function() {

    // User Profile
    // --------------------------------------------------

    $('#esp-user-profile').easyPieChart({
        barColor: '#17A88B',
        trackColor: 'rgba(0,0,0,0)',
        scaleColor: false,
        scaleLength: 0,
        lineCap: 'round',
        lineWidth: 3,
        size: 56,
        animate: {
            duration: 2000,
            enabled: true
        }
    });

});