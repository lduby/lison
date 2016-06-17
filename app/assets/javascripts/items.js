

/* Place all the behaviors and hooks related to the matching controller here. 
 All this logic will automatically be available in application.js. */

//= require circleMenu

$(function(){

    $('#masonry-container').masonry({
        itemSelector: '.box',
        // set columnWidth a fraction of the container width
        columnWidth: function( containerWidth ) {
            return containerWidth / 25;
        },
        gutterWidth: 50,
        isRTL: true
    });

});

$(function(){
    /*var cmenus = document.getElementsByClassName("item-actions");
    for (var i = 0, len = cmenus.length; i < len; i++){
        cmenus[i].circleMenu({
            item_diameter: 40,
            circle_radius: 100,
            direction: 'top-right'
        });
    }*/
    $('ul.item-actions').circleMenu({
        item_diameter: 40,
        circle_radius: 100,
        trigger:'click',
        direction: 'bottom-left'
    });
});