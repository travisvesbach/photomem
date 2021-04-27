console.log('we have contact');

function syncImages() {

    $('button').first().text('syncing ... please wait').prop('disabled', true);

    $('body').css('cursor', 'wait');

    $.ajax({
        type: 'POST',
        url: 'images/sync',
        data: {},
        success: function(data) {
            $('button').first().text('Run Sync').prop('disabled', false);
            $('body').css('cursor', 'inherit');
            alert("Success!" + "\n\nClick 'OK' to refresh the page");
            location.reload();
        },
        error: function(data) {
            $('button').first().text('Run Sync').prop('disabled', false);
            $('body').css('cursor', 'inherit');
            alert("Something went wrong");
        },
    });

}
