const fragment = new DocumentFragment();
const url = 'https://musicbrainz.org/ws/2/genre/all?limit=20&offset=1307&fmt=json';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.genres.forEach(function(genre) {
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