var container = new Array();
var selected = new Array();

/*function toggle(element) {
  $(element).parent().find('.more').toggle();
}

function slider() {
  $('div.slider').toggle();
}

function toggleSchedule() {
  $('div.schedule').toggle();
}

function schedule(element) {
  $(element).parent().find('ul').toggle();
}

function toggleMoreInfo() {
  $('.show_more').toggle();
}*/

function selector(element) {
  $(element).parent().find('ul').toggle();
  container.push($(element).parent().find('ul'));
}

function select(element) {
  var id = $(element).attr('value');
  var genre = $(element).text();
  var toAppend = $(element).parent().attr('value');
  var append = "<div class='selected' onclick='remove(this);' value='" + id + "'>" + genre + "</div>";
  var duplicate = false;
  $.each(selected, function(key, value) {
    if(value == id) {
      duplicate = true;
    }
  });
  if(duplicate == false){
    selected.push(id);
    $('.' + toAppend).append(append);
  }
}

function remove(element) {
  var removeItem = $(element).attr('value');
  //selected.pop($(element).attr('value'));
  selected = jQuery.grep(selected, function(value) {
        return value != removeItem;
      });
  $(element).remove();
}

function multi(element) {
  var parent = $(element).parent();
  $('li.active', parent).removeClass('active');

  $(element).addClass('active');
}

/*$(document).mouseup(function (e)
{

  $.each(container, function(key, value) {
    if (!$(value).is(e.target) && $(value).has(e.target).length === 0)
    {
      $(value).hide();
    }
  });
});*/
