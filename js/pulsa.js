var today = new Date();
var day = today.getDate();
day='#tanggal' + day;

$(document).ready(function() {
    $('.modal-trigger').leanModal();
    var $dayElement =  $(day);
    var $tBody = $('#home-table tbody');
    var $table = $('#home-table table');
    $tBody.scrollLeft($dayElement.position() - ($tBody.outerWidth(true) / 2) + ($dayElement.outerWidth(true) / 2));

    $('#bulanTahun').on('change', function() {
        $('#simulation-form').submit();
    });

    var $table = $('.auto-scroll');
    if ($table.length > 0) {
        $.each($table, function () {
            var $self = $(this);
            var $parent = $self.parent();
            var width = $parent.outerWidth(true);
            var scrollSpeed = 200;
            $parent.css({
                overflow: 'auto'
            });

            $self.mousemove(function (e) {
                if (e.pageX >= $parent.offset().left && e.pageX <= $parent.offset().left + 100) {
                    $parent[0].scrollLeft -= scrollSpeed;
                } else if (e.pageX >= $parent.offset().left + width - 100 && e.pageX <= $parent.offset().left + width) {
                    $parent[0].scrollLeft += scrollSpeed;
                }
            });
        });
    }
});