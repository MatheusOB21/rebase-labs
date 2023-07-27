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
      // Table ExamInfo
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
      
      //Table DoctorInfo
      const trDoctor = document.createElement('tr')
      for(let [key, value] of Object.entries(doctor)){
        trDoctor.appendChild(createTd(value));
        fragment2.appendChild(trDoctor);
      };

      //Table TestsInfo
      const trTests = document.createElement('tr')

      const trType = document.createElement('tr');
      const thType = document.createElement('th');
      thType.innerHTML = 'Exame ';
      trType.appendChild(thType);

      const trLimit = document.createElement('tr');
      const thLimit = document.createElement('th');
      thLimit.innerHTML = 'Limites ';
      trLimit.appendChild(thLimit);
      
      const trResult = document.createElement('tr')
      const thResult = document.createElement('th');
      thResult.innerHTML = 'Resultado ';
      trResult.appendChild(thResult);

      exam_tests.forEach(element => {
        trType.appendChild(createTd(element['type']));
        trLimit.appendChild(createTd(element['limits_type']));
        // element['limits_type'].split('-').map(el => { return parseInt(el)});
        // parseInt(element['result_type']);
        trResult.appendChild(createTd(element['result_type']));
      });
      trTests.appendChild(trType);
      trTests.appendChild(trLimit);
      trTests.appendChild(trResult);
      fragment3.appendChild(trTests);
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
