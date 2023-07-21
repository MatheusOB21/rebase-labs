const fragment = new DocumentFragment();
const url = 'http://0.0.0.0:3000/tests/format=json';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.forEach(function(genre) {
      const li = document.createElement('li');
      li.textContent = `${genre.name}`;
      fragment.appendChild(li);
    })
  }).
  then(() => {
    document.querySelector('ul').appendChild(fragment);
  }).
  catch(function(error) {
    console.log(error);
  });