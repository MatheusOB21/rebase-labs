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
  div.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" height="1.25em" viewBox="0 0 512 512">
                    <!--! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
                    <style>svg{fill:#624de3}</style>
                    <path d="M416 208c0 45.9-14.9 88.3-40 122.7L502.6 457.4c12.5 12.5 12.5 32.8 0 45.3s-32.8 12.5-45.3 0L330.7 376c-34.4 25.2-76.8 40-122.7 40C93.1 416 0 322.9 0 208S93.1 0 208 0S416 93.1 416 208zM208 352a144 144 0 1 0 0-288 144 144 0 1 0 0 288z"/></svg>`;
  div.addEventListener('click', function() {
    window.location.href = `http://0.0.0.0:3000/index/details?token=${exam['result_token']}`;
  })
  td_details = document.createElement('td');
  td_details.appendChild(div);  
  tr.appendChild(td_details);
  fragment.appendChild(tr);
}

function searchExam(){
  value = document.querySelector('input').value;
  tbody = document.querySelector('tbody');

  if(value != ''){
    tbody.innerHTML = ''
    searchUrl = `http://0.0.0.0:3000/tests/${value}`
    setData(searchUrl);
  }else{
    tbody.innerHTML = ''
    setData(url_all)
  }

  console.log(value);
  console.log(searchUrl);
}

window.onload = setData(url_all);
