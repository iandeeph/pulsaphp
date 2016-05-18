var today = new Date();
var day = today.getDate();
day ='#tanggal' + day;

var $tableParent;
var $dayElement;
var $dayPos;

$(document).ready(function() {
    $('.modal-trigger').leanModal();
    $(".button-collapse").sideNav();
    Materialize.updateTextFields();
    $('.collapsible-span').collapsible({
      accordion : true // A setting that changes the collapsible behavior to expandable instead of the default accordion style
    });

    $dayElement = $(day);
    $dayPos = $dayElement.position();

    var $homeTable = $('.home-table table');
    $tableParent = $homeTable.parent();

    $('#bulanTahun').on('change', function() {
        $('#simulation-form').submit();
    });

    var $table = $('.auto-scroll');
    if ($table.length > 0) {
        $.each($table, function () {
            var $self = $(this);
            var $parent = $self.parent();
            var width = $parent.outerWidth(true);
            var scrollSpeed = 50;
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

    if ($homeTable.length > 0) {
        $.each($table, function () {
            $tableParent.scrollLeft($dayPos.left - (($tableParent.outerWidth(true) / 2) - ($dayElement.outerWidth(true) / 2)));
        });
    }

});