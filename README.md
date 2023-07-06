# Rebase Labs

Uma app web para listagem de exames médicos.

---

### Tech Stack

* Docker
* Ruby
* Javascript
* HTML
* CSS

---

### Premissa

A premissa principal deste laboratório é que a app **não seja feita em Rails**, devendo seguir o padrão **Sinatra** que há neste projeto, ou então se preferir, podendo utilizar outro web framework que **não** seja Rails, por ex. grape, padrino, rack, etc ou até mesmo um HTTP/TCP server "na mão".

---

### Laboratório

Abaixo vamos listar os 4 principais objetivos deste laboratório. Mas não se preocupe se nesta fase parecer muita coisa, pois vamos abordar os temas e dicas de cada etapa em diferentes sessões ao longo das próximas 2 semanas.

---

### Feature 1: Importar os dados do CSV para um database SQL

A primeira versão original da API deverá ter apenas um endpoint `/tests`, que lê os dados de um arquivo CSV e renderiza no formato JSON. Você deve _modificar_ este endpoint para que, ao invés de ler do CSV, faça a leitura **diretamente de uma base de dados SQL**.

#### Script para importar os dados

Este passo de "importar" os dados do CSV para um **database SQL** (por ex. PostgreSQL), pode ser feito com um script Ruby simples ou **rake** task, como preferir.

Idealmente deveríamos ser capazes de rodar o script:
```bash
$ ruby import_from_csv.rb
```
E depois, ao consultar o SQL, os dados deveriam estar *populados*.

* _Dica 1_: consultar o endpoint `/tests` para ver como é feita a leitura de um arquivo CSV
* _Dica 2_: utilizar um container para a API e **outro container** para o PostgreSQL. Utilize **networking** do `Docker` para que os 2 containers possam conversar entre si
* _Dica 3_: comandos SQL -> `DROP TABLE`, `INSERT INTO`

#### Modificar a implementação do endpoint atual

O resultado atual que o endpoint traz ao fazer a leitura do CSV, deve ser o mesmo quando modificarmos para ler direto do database.

* _Dica 1_: primeiramente, separar o código que busca os dados em uma classe Ruby separada, pois além de ser mais fácil para testar, facilita o refactoring para quando fizermos a leitura direto do database SQL
* _Dica 2_: testar primeiro as queries SQL direto no database, `SELECT` etc. Depois utilizar um **driver** para o PostgreSQL para que a app Ruby saiba "conversar" com o database.
* _Dica 3_: utilizar a gem `pg` na app Ruby, ou então se preferir, utilizar a gem `ActiveRecord` standalone (fora do Rails) na app.

---

### Feature 2: Exibir listagem de exames no navegador Web
Agora vamos exibir as mesmas informações da etapa anterior, mas desta vez de uma forma mais amigável ao usuário. Para isto, você deve criar uma nova aplicação, que conterá todo o código necessário para a web - HTML, CSS e Javascript.

Criar um endpoint do Sinatra (A) que devolve listagem de exames em formato JSON.

Adicionar também, outro endpoint do Sinatra (B) que devolve um HTML contendo apenas instruções Javascript. Estas instruções serão responsáveis por buscar os exames no enponint (A) e exibi-los na tela de forma amigável.

O objetivo aqui, neste passo, é carregar os dados de exames da API utilizando Javascript. Como exemplo, você pode abrir em seu browser o arquivo `index.html` contido neste snippet e investigar seu funcionamento.

* _Dica 1_: Pesquise sobre `Fetch API`, uma API Javascript para execução de requisições web.
* _Dica 2_: Utilize o `console` das `developer tools` do seu browser para experimentar com Javascript e Fetch API.
* _Dica 3_: Pesquise sobre DOM, uma API Javascript para manipular uma estrutura de documentos (seu HTML é um tipo de documento).
* _Dica 4_: Utilize CSS para estilizar a página e deixá-la mais amigável ao usuário.

#### Exemplo do request e response
Request:
```bash
GET /tests
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

### Feature 3: Exibir detalhes de um exame em formato HTML a partir do token do resultado
Nesta etapa vamos implementar uma nova funcionalidade: pesquisar os resultados com base em um token de exame. 

Você deve criar um endpoint no Sinatra (C) que devolve, com base no token enviado no request, os detalhes de um exame em formato JSON.

Adicionalmente, também criar, no HTML da listagem de exames, uma tag HTML `<form>` que via Javascript faz request ao endpoint (C) e renderiza os detalhes do exame em HTML.

#### Criar endpoint para mostrar os detalhes de um exame médico

Você deve implementar o endpoint `/tests/:token` que permita que o usuário da API, ao fornecer o token do exame, possa ver os detalhes daquele exame no formato JSON, tal como está implementado no endpoint
`/tests`. A consulta deve ser feita na base de dados.

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

* _Dica_: consultar no database SQL com `SELECT` e depois, trabalhar em cima dos dados de resposta **antes** de renderizar o JSON

---

### Feature 4: Importar resultados de exames em formato CSV de forma assíncrona
Neste momento fazemos o import através de um script. Mas este script tem que ser executado por alguém developer ou admin do sistema.

Para melhorar isto, idealmente qualquer usuário da API poderia chamar um endpoint para atualizar os dados. Assim, o endpoint deveria aceitar um arquivo CSV dinâmico e importar os dados para o PostgreSQL.

Exemplo:
```bash
$ POST /import
```

#### Implementar endpoint para receber um CSV no HTTP request
Neste passo, devemos focar apenas em receber o CSV via HTTP e utilizar o mesmo código do script de import para popular o database.

* _Dica 1_: receber o **conteúdo do CSV** no HTTP request body
* _Dica 2_: pode usar a ferramenta `Postman` para testar os pedidos via HTTP. Pode também utilizar o `curl` para isto
* _Dica 3_: nesta fase, ainda fazer o processo "síncrono", ou seja, o usuário que chamar o endpoint `POST /import` deve ficar à espera

#### Executar o import do endpoint de forma assíncrona em background
Uma vez que fizemos o endpoint de `POST /import`, agora vamos focar numa implementação que permita que o usuário não fique _à espera_, ou seja, executar em um **background job**, mesmo o usuário sabendo que
não vai ficar pronto imediatamente. Neste caso, o processo de import fica pronto **eventualmente**.

* _Dica 1_: utilizar o `Sidekiq` para o processamento assíncrono
* _Dica 2_: o Sidekiq roda em um container separado da API
* _Dica 3_: subir um container para a visualização "Web" das filas do Sidekiq

#### Botão de "Importar CSV" na página Web em formato HTML
Neste momento, o processo de importar o CSV está manual com chamada direta ao endpoint `POST /import`. Para simplificar a quem utiliza a plataforma, a página HTML com a listagem pode trazer um botão que faz a requisição com o upload do conteúdo do arquivo CSV.

* _Dica 1_: o botão ficará "estático" no HTML
* _Dica 2_: a ação do botão deverá fazer o pedido à API (`POST /import`), **enviando o conteúdo** do CSV no corpo do request

---

### Como as sessões serão estruturadas
Iremos realizar 4 sessões de aprendizado nos principais temas que serão abordados durante o laboratório.

* Sessão 1: Docker, Sinatra e SQL
* Sessão 2: HTTP e Web (Javascript, HTML e CSS)
* Sessão 3: Processamento assíncrono (Sidekiq)
* Sessão 4: Easter egg, tirar dúvidas finais e encerramento

---

### Nossos valores
Aqui listamos alguns valores que compartilhamos sobre engenharia de software.

#### Valorizamos documentação
Tente documentar o máximo possível sobre sua aplicação em arquivos `Markdown` (como este aqui por exemplo) ou então em páginas wiki.

Uma boa documentação é a *base* para a comunicação e boa saúde de um projeto de software.

#### Valorizamos testes
Testes são uma parte crucial no desenvolvimento de software. Se teu projeto não tem testes, não há garantias automatizadas de que ele vai continuar funcionando ao longo do tempo, à medida que mais código é adicionado nele.

---

### Dúvidas?
Em caso de dúvidas sobre qualquer um dos labs ou conteúdo das sessões, fique à vontade para conversar na ferramenta de comunicação do programa.