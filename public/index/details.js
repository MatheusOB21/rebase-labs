const fragment1 = new DocumentFragment();
const fragment2 = new DocumentFragment();
const fragment3 = new DocumentFragment();
const queryString= window.location.search
const urlParams = new URLSearchParams(queryString);
const token = urlParams.get('token')
console.log(token);
const url = `http://0.0.0.0:3000/tests/${token}`;

const h1 = document.querySelector('h1');
h1.textContent = `Detalhes do Exame: ${token}`

fetch(url).
  then((response) => response.json()).
  then((data) => {
    if (!(data instanceof Array)){data = [data]}
    data.forEach(function(exam) {
      const patient = exam.patient;
      const doctor = exam.doctor;
      const exam_tests = exam.tests;
      const exam_result = {result_token: exam.result_token, result_date: exam.result_date};
      
      const trInfo = document.createElement('tr');
      for(let [key, value] of Object.entries(exam_result)){
        trInfo.appendChild(createTd(value));
        trInfo.id = exam_result['result_token'];
        fragment1.appendChild(trInfo);
      };

      for(let [key, value] of Object.entries(patient)){
        trInfo.appendChild(createTd(value));
        fragment1.appendChild(trInfo);
      };
 
      const trDoctor = document.createElement('tr')
      for(let [key, value] of Object.entries(doctor)){
        trDoctor.appendChild(createTd(value));
        fragment2.appendChild(trDoctor);
      };

      exam_tests.forEach(element => {
        const trTests = document.createElement('tr')
        for(let [key, value] of Object.entries(element)){
          trTests.appendChild(createTd(value));
          fragment3.appendChild(trTests);
        };
      });

    })
  }).
  then(() => {
    document.querySelector('table#examInfo tbody').appendChild(fragment1);
    document.querySelector('table#doctorInfo tbody').appendChild(fragment2);
    document.querySelector('table#testsInfo tbody').appendChild(fragment3);
  }).
  catch(function(error) {
    console.log(error);
  });

function createTd(params) {
  td = document.createElement('td');
  td.textContent = `${params}`;
  return td;
}
