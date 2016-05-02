var today = new Date();
var day = today.getDate();
day='#tanggal' + day;

$(document).ready(function() {
    $('.modal-trigger').leanModal();
    var $dayElement =  $(day);
    var $tBody = $('#simulation-table tbody');
    var $table = $('#simulation-table table');
    $tBody.scrollLeft($dayElement.position().left - ($tBody.outerWidth(true) / 2) + ($dayElement.outerWidth(true) / 2));

    $('#bulanTahun').on('change', function() {
        $('#simulation-form').submit();
    });
});