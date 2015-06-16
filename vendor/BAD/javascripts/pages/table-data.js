$(document).ready(function() {

  // Datatables
  $('#example').DataTable();

  var table = $('#example2').DataTable({
    "columnDefs": [
      { "visible": false, "targets": 2 }
    ],
    "order": [[ 2, 'asc' ]],
    "displayLength": 25,
    "drawCallback": function ( settings ) {
      var api = this.api();
      var rows = api.rows( {page:'current'} ).nodes();
      var last=null;

      api.column(2, {page:'current'} ).data().each( function ( group, i ) {
        if ( last !== group ) {
          $(rows).eq( i ).before(
            '<tr class="group"><td colspan="5">'+group+'</td></tr>'
          );

          last = group;
        }
      } );
    }
  });
});

/*
$.fn.isValid = function(){
    return this[0].checkValidity()
}

var t = $('#example3').DataTable();


$('#add-row').on( 'click', function () {
    if($("#add-row-form").isValid()) {
        var name = $('#name-input').val(),
            position = $('#position-input').val(),
            age = $('#age-input').val(),
            date = $('#date-input').val(),
            salary = $('#salary-input').val();
        t.row.add( [
            name,
            position,
            age,
            date,
            '$' + salary
        ] ).draw();

        $('.modal').modal('hide');

        return false;
    }
});

$('.date-picker').datepicker({
    orientation: "top auto",
    autoclose: true
});
*/
