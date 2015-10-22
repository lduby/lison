/* Place all the behaviors and hooks related to the matching controller here. 
 All this logic will automatically be available in application.js. */

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