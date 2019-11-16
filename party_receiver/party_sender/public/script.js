$('#submit').click( (e) => {
  $.ajax({
      url:'/submit',
      type:'post',
      data:{textbox: $('#textbox').val()},
      success:function(){
          $('#textbox').val('')
      }
  });
  return false;
})

// $('#textbox').bind('input propertychange', (e) => {
//   $('#textbox'.val().length >= 30)
// });
