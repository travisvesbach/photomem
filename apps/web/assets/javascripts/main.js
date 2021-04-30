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


function removeDirectory(url) {

    if(confirm('Are you sure you?\n\nSynced images will also be removed.\n\nNote: Removed images and directories will be re-added when syncing a parent directory.')) {

        $('button').prop('disabled', true);
        $('.alert-syncing').css('display', 'flex');
        $('body').css('cursor', 'wait');

        $.ajax({
            type: 'POST',
            url: url,
            data: { "_method": "DELETE" },
            datatype: "json",
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
}
