var check = 0;
var index = 0;
var childrenCount;
var shift = 0;
var coeff;
var perPage = 5;

function setSize() {
  var width = $(window).width();
  calculateVars();
}

$(window).resize(setSize);

$('document').ready(function() {
  childrenCount = $("div.element").length;
  calculateVars();
});

function calculateVars() {
  var sliderWidth = parseInt($('div.slider').css('width'));
  var childrenWidth = parseInt($('div.element').css('width'));

  coeff = ((childrenWidth / sliderWidth) * 100);
  console.log(coeff);
}

function next(element) {

  if((index + 1) == childrenCount) {
    //$('.next').removeClass('active');
  } else if((index + 1) < childrenCount) {
    index++;
    shift = index * coeff;
    $('div#0').css('margin-left', - shift + '%');
    check = 1;
    $('.previous').addClass('active');
  }

  toggleActive();
}

function previous(element) {
  if((index - 1) < 0) {
    //$('.previous').removeClass('active');
  } else if((index - 1) >= 0) {
    index--;
    shift = index * coeff;
    $('div#0').css('margin-left', - shift + '%');
    check = 1;
    $('.next').addClass('active');
  }

  toggleActive();
}


function toggleActive() {
  if(index == 0){
    $('.previous').removeClass('active');
  }

  if(index < childrenCount){
    $('.next').addClass('active');
  }

  if(index < childrenCount && index > 0) {
    $('.previous').addClass('active');
  }

  if(index+1 == childrenCount) {
    $('.next').removeClass('active');
  }
}
