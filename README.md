# Rebase Labs

Uma aplicação usada para a listagem de exames médicos a partir do banco de dados Postgrees, utilizando tecnologias ruby.
A aplicação é feita com a gem Sinatra <span style="margin-left: 3px; margin-right: 3px;">[![Gem Version](https://badge.fury.io/rb/sinatra.svg)](https://badge.fury.io/rb/sinatra)</span> e com a execução assíncrona dos dados pela gem Sidekiq <span style="margin-left: 3px; margin-right: 3px;">[![Gem Version](https://badge.fury.io/rb/sidekiq.svg)](https://rubygems.org/gems/sidekiq).</span>

---

### Tecnologias

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)
---

### Requisitos

* Docker instalado: https://www.docker.com/ 
---

### Como rodar a aplicação?

Clone aplicação
```bash
$ git clone https://github.com/MatheusOB21/rebase-labs.git
```
Entre no diretório criado
```bash
cd rebase-labas
```
Executue o comando para subir os containers
```bash
$ bash bin/setup
```
ou

```bash
$ bin/setup
```
Após isso sua aplicação estará rodando no seguinte endereço:  http://0.0.0.0:3000

### Como rodar os testes?

Com a aplicação rodando, execute o seguinte comando em outro terminal
```bash
$ bash bin/rspec
```
ou

```bash
$ bin/rspec
```

### Como parar a aplicação?

No terminal que está rodando a aplicação, basta apertar o conjunto de teclas: Ctrl-C

### Como parar e remover os containers da aplicação?

Em outro terminal, rode o seguinte comando:
```bash
$ bash bin/down
```
ou

```bash
$ bin/down
```
*_Obs_ : Esse comando irá remover os containers e a rede criada para conexão deles. 

---
### Endpoints da aplicação API
#### 1: Listagem de todos os testes/exames cadastrados em JSON

O endpoint `/tests`, lê os dados do **banco de dados** e renderiza em um formato simples, no formato JSON. 

#### Exemplo do request e response

Request:
```bash
GET /tests
```

Response:
```json
[{
   "cpf":"048.973.170-99",
   "patient_name":"Guilheme Lima Alves",
   "patient_email":"gerald.crona@ebert-quigley.com",
   "patient_birth_date":"2001-03-11",
   "patient_address":"165 Rua Rafaela",
   "patient_city":"Ituverava",
   "patient_state":"Alagoas",
   "doctor_crm":"B000XJ20J4",
   "doctor_crm_state":"PI",
   "doctor_name":"Maria Luiza Pires",
   "doctor_email":"denna@wisozk.biz",
   "exam_result_token":"ADFZ17",
   "exam_date":"2021-08-05",
   "exam_type":"hemácias",
   "limits_exam_type":"45-52",
   "result_exam_type":"97"
   },
   {
   "cpf":"048.108.078-05",
   "patient_name":"Jasmine Da Mendes",
   "patient_email":"mariana_crist@kutch-torp.com",
   "patient_birth_date":"1995-07-03",
   "patient_address":"527 Rodovia Júlio",
   "patient_city":"Lagoa da Canoa",
   "patient_state":"Paraíba",
   "doctor_crm":"B0002IFG76",
   "doctor_crm_state":"SC",
   "doctor_name":"Maria Helena Ramalho",
   "doctor_email":"rayford@kemmer-kunze.info",
   "exam_result_token":"OX1I67",
   "exam_date":"2021-07-09",
   "exam_type":"leucócitos",
   "limits_exam_type":"9-61",
   "result_exam_type":"91"
}]
   
```
---
#### 2: Listagem de todos os testes/exames cadastrados em JSON, com formatação e tratamento de dados.

O endpoint `/tests/format=json`, lê os dados do **banco de dados** e renderiza no formato JSON, porém com formatação e tratamento dos dados

#### Exemplo do request e response

Request:
```bash
GET /tests/format=json
```

Response:

```json
[{
   "result_token":"T9O6AI",
   "result_date":"2021-11-21",
   "cpf":"066.126.400-90",
   "name":"Matheus Barroso",
   "email":"maricela@streich.com",
   "birthday":"1972-03-09",
   "doctor": {
      "crm":"B000B7CDX4",
      "crm_state":"SP",
      "name":"Sra. Calebe Louzada"
   },
   "tests":[
      {
         "type":"hemácias",
         "limits":"45-52",
         "result":"48"
      },
      {
         "type":"leucócitos",
         "limits":"9-61",
         "result":"75"
      },
      {
         "test_type":"plaquetas",
         "test_limits":"11-93",
         "result":"67"
      },
      {
         "test_type":"hdl",
         "test_limits":"19-75",
         "result":"3"
      },
      {
         "test_type":"ldl",
         "test_limits":"45-54",
         "result":"27"
      },
      {
         "test_type":"vldl",
         "test_limits":"48-72",
         "result":"27"
      },
      {
         "test_type":"glicemia",
         "test_limits":"25-83",
         "result":"78"
      },
      {
         "test_type":"tgo",
         "test_limits":"50-84",
         "result":"15"
      },
      {
         "test_type":"tgp",
         "test_limits":"38-63",
         "result":"34"
      },
      {
         "test_type":"eletrólitos",
         "test_limits":"2-68",
         "result":"92"
      },
      {
         "test_type":"tsh",
         "test_limits":"25-80",
         "result":"21"
      },
      {
         "test_type":"t4-livre",
         "test_limits":"34-60",
         "result":"95"
      },
      {
         "test_type":"ácido úrico",
         "test_limits":"15-61",
         "result":"10"
      }
   ]
}]
```
---
#### 3: Listagem dos detalhes de um exame cadastrado em JSON, a partir de um token.

O endpoint `/tests/:token` recebe um token como parâmetro e retora a partir do **banco de dados** um exame com aquele token. Caso seja informado um token que existe, ele renderiza os detalhes desse exame.

#### Exemplo do request e response
Request:
```bash
GET /tests/T9O6AI
```
Response:

```json
{
   "result_token":"T9O6AI",
   "result_date":"2021-11-21",
   "cpf":"066.126.400-90",
   "name":"Matheus Barroso",
   "email":"maricela@streich.com",
   "birthday":"1972-03-09",
   "doctor": {
      "crm":"B000B7CDX4",
      "crm_state":"SP",
      "name":"Sra. Calebe Louzada"
   },
   "tests":[
      {
         "type":"hemácias",
         "limits":"45-52",
         "result":"48"
      },
      {
         "type":"leucócitos",
         "limits":"9-61",
         "result":"75"
      },
      {
         "test_type":"plaquetas",
         "test_limits":"11-93",
         "result":"67"
      },
      {
         "test_type":"hdl",
         "test_limits":"19-75",
         "result":"3"
      },
      {
         "test_type":"ldl",
         "test_limits":"45-54",
         "result":"27"
      },
      {
         "test_type":"vldl",
         "test_limits":"48-72",
         "result":"27"
      },
      {
         "test_type":"glicemia",
         "test_limits":"25-83",
         "result":"78"
      },
      {
         "test_type":"tgo",
         "test_limits":"50-84",
         "result":"15"
      },
      {
         "test_type":"tgp",
         "test_limits":"38-63",
         "result":"34"
      },
      {
         "test_type":"eletrólitos",
         "test_limits":"2-68",
         "result":"92"
      },
      {
         "test_type":"tsh",
         "test_limits":"25-80",
         "result":"21"
      },
      {
         "test_type":"t4-livre",
         "test_limits":"34-60",
         "result":"95"
      },
      {
         "test_type":"ácido úrico",
         "test_limits":"15-61",
         "result":"10"
      }
   ]
}
```

Porém caso seja informado apenas algumas letras, ele irá retornar vários exames que possuam aquele pedaço.

#### Exemplo do request e response
Request:
```bash
GET /tests/OL
```
Response:

```json
[{
   "result_token":"AOL9ST",
   "result_date":"2021-06-26",
   "patient":{
      "cpf":"048.973.170-88",
      "name":"Emilly Batista Neto",
      "email":"gerald.crona@ebert-quigley.com",
      "birthday":"2001-03-11",
      "address":"165 Rua Rafaela",
      "city":"Ituverava",
      "state":"Alagoas"
   },
   "doctor":{
      "crm":"B0002W2RBG",
      "crm_state":"CE",
      "name":"Dra. Isabelly Rêgo"
   },
   "tests":[
      {"
         type":"hemácias",
         "limits_type":"45-52",
         "result_type":"0"
      },
      {
         "type":"leucócitos",
         "limits_type":"9-61",
         "result_type":"72"
      },
      {
         "type":"plaquetas"
         ,"limits_type":"11-93",
         "result_type":"56"
      },
      {
         "type":"hdl",
         "limits_type":"19-75",
         "result_type":"19"
      },
      {
         "type":"ldl",
         "limits_type":"45-54",
         "result_type":"53"
      },
      {
         "type":"vldl",
         "limits_type":"48-72",
         "result_type":"19"
      },
      {
         "type":"glicemia",
         "limits_type":"25-83",
         "result_type":"48"
      },
      {
         "type":"tgo",
         "limits_type":"50-84",
         "result_type":"92"
      },
      {
         "type":"tgp",
         "limits_type":"38-63",
         "result_type":"100"
      },
      {
         "type":"eletrólitos",
         "limits_type":"2-68",
         "result_type":"69"
      },
      {
         "type":"tsh",
         "limits_type":"25-80",
         "result_type":"8"
      },
      {
         "type":"t4-livre",
         "limits_type":"34-60",
         "result_type":"7"
      },
      {
         "type":"ácido úrico",
         "limits_type":"15-61",
         "result_type":"6"
      }
   ]},
   {
      "result_token":"DW9OLA",
      "result_date":"2021-12-24",
      "patient":{
         "cpf":"094.010.477-66",
         "name":"Meire Paes",
         "email":"billie.bernier@ankunding-ratke.co",
         "birthday":"1981-06-24",
         "address":"7187 Rua Mariah",
         "city":"Rio Negro",
         "state":"Roraima"
      },
      "doctor":{
         "crm":"B0002W2RBG",
         "crm_state":"CE",
         "name":"Dra. Isabelly Rêgo"
      },
      "tests":[
         {
            "type":"hemácias",
            "limits_type":"45-52",
            "result_type":"94"
         },
         {
            "type":"leucócitos",
            "limits_type":"9-61",
            "result_type":"97"
         },
         {
            "type":"plaquetas",
            "limits_type":"11-93",
            "result_type":"35"
         },
         {
            "type":"hdl",
            "limits_type":"19-75",
            "result_type":"61"
         },
         {
            "type":"ldl",
            "limits_type":"45-54",
            "result_type":"56"
         },
         {
            "type":"vldl",
            "limits_type":"48-72",
            "result_type":"4"
         },
         {
            "type":"glicemia",
            "limits_type":"25-83",
            "result_type":"76"
         },
         {
            "type":"tgo",
            "limits_type":"50-84",
            "result_type":"44"
         },
         {
            "type":"tgp",
            "limits_type":"38-63",
            "result_type":"1"
         },
         {
            "type":"eletrólitos",
            "limits_type":"2-68",
            "result_type":"100"
         },
         {
            "type":"tsh",
            "limits_type":"25-80",
            "result_type":"78"
         },
         {
            "type":"t4-livre",
            "limits_type":"34-60",
            "result_type":"8"
         },
         {
            "type":"ácido úrico",
            "limits_type":"15-61",
            "result_type":"97"
         }]
   }]
```
---
#### 4: Importação de dados a partir dos dados de um CSV

O endpoint `/import` realiza a importação dos dados de um arquivo CSV para o **banco de dados**.

#### Exemplo do request
Request:
```bash
POST /import
```
Modelo de arquivo CSV
```csv
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;hemácias;45-52;97
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;leucócitos;9-61;89
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;plaquetas;11-93;97
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;hdl;19-75;0
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;ldl;45-54;80
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;vldl;48-72;82
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;glicemia;25-83;98
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tgo;50-84;87
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tgp;38-63;9
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;eletrólitos;2-68;85
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tsh;25-80;65
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;t4-livre;34-60;94
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;ácido úrico;15-61;2
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;hemácias;45-52;28
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;leucócitos;9-61;91
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;plaquetas;11-93;18
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;hdl;19-75;74
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;ldl;45-54;66
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;vldl;48-72;41
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;glicemia;25-83;6
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tgo;50-84;32
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tgp;38-63;16
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;eletrólitos;2-68;61
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tsh;25-80;13
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;t4-livre;34-60;9
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;ácido úrico;15-61;78
```
#### Como utilizar esse endpoint?
Você pode realizar um `POST` via CURL pelo terminal, passando o conteúdo do CSV como corpo do HTTP.

Exemplo:
```bash
curl -X POST http://0.0.0.0:3000/import -d "cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;hemácias;45-52;97
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;leucócitos;9-61;89
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;plaquetas;11-93;97
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;hdl;19-75;0
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;ldl;45-54;80
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;vldl;48-72;82
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;glicemia;25-83;98
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tgo;50-84;87
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tgp;38-63;9
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;eletrólitos;2-68;85
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;tsh;25-80;65
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;t4-livre;34-60;94
048.973.170-99;Guilheme Lima Alves;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000XJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;ADFZ17;2021-08-05;ácido úrico;15-61;2
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;hemácias;45-52;28
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;leucócitos;9-61;91 
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;plaquetas;11-93;18 
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;hdl;19-75;74
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;ldl;45-54;66
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;vldl;48-72;41
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;glicemia;25-83;6
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tgo;50-84;32
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tgp;38-63;16
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;eletrólitos;2-68;61
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;tsh;25-80;13
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;t4-livre;34-60;9
048.108.078-05;Jasmine Da Mendes;mariana_crist@kutch-torp.com;1995-07-03;527 Rodovia Júlio;Lagoa da Canoa;Paraíba;B0002IFG76;SC;Maria Helena Ramalho;rayford@kemmer-kunze.info;OX1I67;2021-07-09;ácido úrico;15-61;78"
```
### Endpoints da aplicação WEB
#### 1: Listagem de todos os testes/exames cadastrados, em HTML

O endpoint `/index`, lê os dados do **banco de dados** e renderiza em um formato de tabelas, no formato HTML. 

#### Tela:

Nessa tela inicial é possível pesquisar por exames a partir do token:

É possível realizar o importe de dados de exames, a partir de um arquivo CSV:

---
#### 2: Listagem dos detalhes de um test/exame cadastrado, em HTML

O endpoint `/details?token=:token`, lê os dados do **banco de dados** e renderiza em um formato de tabelas, no formato HTML, os detalhes de um exame a partir do token. 

#### Tela:

Essa tela é acessível pela tela inicial, a partir do ícone "I":

### Dúvidas?
Em caso de dúvidas sobre a aplicação, fique à vontade para entrar em contato: **matheus53barros@gmail.com**