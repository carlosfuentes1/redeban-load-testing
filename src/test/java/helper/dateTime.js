function generateDateTimeVariables() {
  let date = new Date();
  var dia = date.toISOString().split('T')[0].replace(/-/g, '');
  var hora = date.getHours();
  if (hora <= 9) {
    hora = '0' + date.getHours();
  } else {
    hora = date.getHours();
  }
  var min = date.getMinutes();
  if (min <= 9) {
    min = '0' + date.getMinutes();
  } else {
    min = new Date().getMinutes();
  }

  return {
    dia: dia,
    date: dia+''+hora+''+min+'00',
    hora: hora+''+min
  };
}
