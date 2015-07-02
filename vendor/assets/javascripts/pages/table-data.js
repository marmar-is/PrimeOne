$(document).ready(function() {

  $.fn.isValid = function(){
      return this[0].checkValidity()
  }

  // Datatables
  var t = $('#example').DataTable();

  /*
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
  */

  $('#add-row').on( 'click', function () {
    if($("#add-row-form").isValid()) {
      /*var number_ = $('#number-input').val(),
      code_ = $('#code-input').val(),
      name_ = $('#name-input').val(),
      effective_ = $('#effective-input').val(),
      broker_id_ = $('#broker_id-input').val(),
      status_ = 'EMPTY';*/

      console.log($('#effective-input').val());

      $.ajax({
        type: "POST",
        url: "/policies",
        dataType: "json",
        data:{
          policy: {
            number: $('#number-input').val(),
            code: $('#code-input').val(),
            name: $('#name-input').val(),
            effective: $('#effective-input').val(),
            broker_id: $('#broker_id-input').val(),
            status: 'EMPTY'
          }
        },
        success: function(data){
          console.log(data);
          /*t.row.add([
            number,
            code,
            name,
            effective,
            broker,
            status
          ]);*/
          //$("#posts").append('<tr><td>data.title</td>
          //<td>data.body</td>
          //<td>data.author</td></tr>');
          $('.modal').modal('hide');
        },
        error: function(data){
          console.log('error');
        }
      });

      return false;
    }
  });

  $('.date-picker').datepicker({
    format: "yyyy-mm-dd",
    orientation: "top auto",
    autoclose: true
  });
});

/*
var t = $('#example3').DataTable();
*/
