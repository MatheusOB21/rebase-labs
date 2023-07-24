const fragment = new DocumentFragment();
const url_all = 'http://0.0.0.0:3000/tests/format=json';

function setData(url){ 
  fetch(url).
    then((response) => response.json()).
    then((data) => {
      if (!(data instanceof Array)){data = [data]}
      data.forEach(function(exam) {
        const patient = exam.patient;
        const doctor = exam.doctor;
        const exam_tests = exam.tests;
        const exam_result = {result_token: exam.result_token, result_date: exam.result_date};
        const tr = document.createElement('tr');

        for(let [key, value] of Object.entries(exam_result)){
          tr.appendChild(createTd(value));
          tr.id = exam_result['result_token'];
          fragment.appendChild(tr);
        };

        for(let [key, value] of Object.entries(patient)){
          tr.appendChild(createTd(value));
          fragment.appendChild(tr);
          if (key == 'birthday'){break};
        };
        
        creatDetailsElement(tr, exam);
  
        // for(let [key, value] of Object.entries(doctor)){
        //   tr.appendChild(createTd(value));
        //   fragment.appendChild(tr);
        // };

  
        // const tr_details = document.createElement('tr')
        // exam_tests.forEach(element => {
        //   tr2 = document.createElement('td')
        //   for(let [key, value] of Object.entries(element)){
        //     tr2.innerHTML = `${element['type']}`;
        //   };
        //   tr_details.appendChild(tr2);
        //   fragment.appendChild(tr_details);
        // });

      })
    }).
    then(() => {
      document.querySelector('tbody').appendChild(fragment);
    }).
    catch(function(error) {
      console.log(error);
    });
}

function createTd(params) {
  td = document.createElement('td');
  td.textContent = `${params}`;
  return td;
}

function creatDetailsElement(tr, exam){
  const div = document.createElement('div');
  div.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" height="1.5em" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z"/></svg>`;
  div.addEventListener('click', function() {
    window.location.href = `http://0.0.0.0:3000/index/details?token=${exam['result_token']}`;
  })
  td_details = document.createElement('td');
  td_details.appendChild(div);  
  tr.appendChild(td_details);
  fragment.appendChild(tr);
}

function searchExam(){
  value = document.querySelector('input#search').value;
  tbody = document.querySelector('tbody');

  if(value != ''){
    tbody.innerHTML = ''
    searchUrl = `http://0.0.0.0:3000/tests/${value}`
    setData(searchUrl);
  }else{
    tbody.innerHTML = ''
    setData(url_all)
  }
}

function inputFile(){
  document.getElementById('input_import').click()
}

async function sentPost(event){
  const file = event.target.files.item(0)
  const text = await file.text();
  await fetch(`http://0.0.0.0:3000/import`, {
    method: 'POST',
    body: `${text}`
  }).then(() => {
    location.reload()
  })
}


window.onload = setData(url_all);
