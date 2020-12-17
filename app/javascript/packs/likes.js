$(document).on('turbolinks:load', function() {
    $('.like').on('ajax:success', function(e) {
        let rating = e.detail[0]['rating'];
        let resourceName = e.detail[0]['resourceName'];
        let resourceId = e.detail[0]['resourceId'];

        console.log("rating = " + rating);
        console.log("resourceName = " + resourceName);
        console.log("resourceId = " + resourceId);
        console.log("$('#' + resourceName + '_' + resourceId + ' .like .rating') = " + '#' + resourceName + '_' + resourceId + ' .like .rating');

        $('#' + resourceName + '_' + resourceId + ' .like .rating').html(rating)
    })
});
