/*
ты обо мне несправедливого мнения, про scope метод я подумал с самого начала,
но так задание же на ajax, вот я и решил пойти путем джаваскрипта
*/

$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
  sortAnswers();
});

function sortAnswers() {
  var answers = document.getElementsByClassName('answer')
  var answers_array = Array.prototype.slice.call(answers)

  answers_array.sort(function(a, b) {
    return a.children[1].getAttribute('data-best') < b.children[1].getAttribute('data-best')
  })

  for(var i = 0; i < answers_array.length; i++) {
    var parent = answers_array[i].parentNode;
    var detachedItem = parent.removeChild(answers_array[i]);
    parent.appendChild(detachedItem);
  }
}
