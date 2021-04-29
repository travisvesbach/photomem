function runSync(url) {

    $('button').prop('disabled', true);
    $('.alert-syncing').css('display', 'flex');
    $('body').css('cursor', 'wait');

    $.ajax({
        type: 'POST',
        url: url,
        data: {},
        success: function(data) {
            $('.alert-syncing').css('display', 'none');
            $('button').prop('disabled', false);
            $('body').css('cursor', 'inherit');
            alert("Success!" + "\n\nClick 'OK' to refresh the page");
            location.reload();
        },
        error: function(data) {
            $('.alert-syncing').css('display', 'none');
            $('button').prop('disabled', false);
            $('body').css('cursor', 'inherit');
            alert("Something went wrong");
        },
    });

}
