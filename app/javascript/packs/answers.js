console.log('answers.js!!!')
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
  //console.log('sortAnswers!!!')
  var answers = document.getElementById('ans').getElementsByClassName('answer')
  console.log(answers)
  var answers_array = Array.prototype.slice.call(answers)

  console.log(answers_array)

  answers_array.sort(function(a, b) {
    return a.children[1].getAttribute('data-best') < b.children[1].getAttribute('data-best')
  })

  for(var i = 0; i < answers_array.length; i++) {
    var parent = answers_array[i].parentNode;
    var detachedItem = parent.removeChild(answers_array[i]);
    parent.appendChild(detachedItem);
  }
}
