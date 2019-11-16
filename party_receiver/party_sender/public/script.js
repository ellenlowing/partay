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
