# Rebase Labs

Uma app web para listagem de exames médicos.

## Tech Stack

* Docker
* Ruby
* Javascript
* HTML
* CSS

## Premissa

A premissa principal deste laboratório é que a app **não seja feita em Rails**, devendo seguir o padrão **Sinatra** que há neste projeto, ou então se preferir, podendo utilizar outro web framework que **não** seja Rails, por ex. grape, padrino, rack, etc ou até mesmo um HTTP/TCP server "na mão".

## Laboratório

Abaixo vamos listar os 4 principais objetivos deste laboratório, seguidos de uma sessão bônus. Mas não se preocupe se nesta fase parecer muita coisa, pois vamos abordar os temas e dicas de cada etapa em diferentes sessões.

### Lab 1: Importar os dados do CSV para um database SQL

A primeira versão original da API deverá ter apenas um endpoint `/tests`, que lê os dados de um arquivo CSV e renderiza no formato JSON. Você pode _modificar_ este endpoint para que, ao invés de ler do CSV, faça a leitura **diretamente de uma base de dados SQL**.

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

### Lab 2: Exibir exames em um front-end HTML
Agora vamos exibir as mesmas informações da etapa anterior, mas desta vez de uma forma mais amigável ao usuário. Para isto, você deve criar uma nova aplicação, que conterá todo o código front-end necessário - HTML, CSS e Javascript.

Ao final teremos duas aplicações distintas:
1. O back-end: representado pela API trabalhada no exercício anterior. A principal função desta aplicação é armazenar os dados de exames e expô-los por meio de uma API.

2. O front-end: representado pela nova aplicação criada nesta etapa. Sua principal função é consultar os dados através da API de exames e exibí-los ao usuário de uma maneira amigável.

#### Carregar os exames na API utilizando Javascript
Para simular uma aplicação front-end crie uma nova pasta, fora da estrutura da aplicação da API, para conter todos os arquivos Javascript, HTML e CSS que você criar.

Esta "aplicação" será bastante simples e rodará diretamente no seu browser com o comando `open`, ou então clicando diretamente no arquivo HTML, que deverá ser aberto pelo seu navegador web padrão.

O objetivo aqui, neste passo, é carregar os dados de exames da API utilizando Javascript. Como exemplo, você pode abrir em seu browser o arquivo `index.html` contido aqui no projeto da API e investigar seu funcionamento.


* _Dica 1_: Pesquise sobre `Fetch API`, uma API Javascript para execução de requisições web.
* _Dica 2_: Utilize o `console` das `developer tools` do seu browser para experimentar com Javascript e Fetch API.
* _Dica 3_: Neste momento não preocupe-se ainda com a exibição dos dados na tela. Algo bem simples ou mesmo um `console.log` já deve ser o suficiente.

#### Exibir na tela os dados do JSON retornado pela API utilizando HTML e CSS
Agora que você já buscou os dados da API o que você precisa fazer é extrair deles as informações importantes e exibí-las na tela, utilizando HTML. O desafio aqui é "inserir" na página HTML os dados que estão no Javascript.

* _Dica 1_: Pesquise sobre DOM, uma API Javascript para manipular uma estrutura de documentos (seu HTML é um tipo de documento).
* _Dica 2_: Utilize CSS para estilizar a página e deixá-la mais amigável ao usuário.

### Lab 3: Filtrar exames a partir de um token de resultado
Nesta etapa vamos implementar uma nova funcionalidade: pesquisar os resultados com base em um token de exame. Para isso precisaremos alterar nossas duas aplicações:

1. O front-end para que possa ser possível realizar a pesquisa através de um campo de busca na tela;
2. O back-end para que possa receber o token digitado no front-end e retornar apenas os dados associados àquele exame;

#### Criar endpoint para mostrar os detalhes de um exame médico

Implementar o endpoint `/tests/:token` que permita que o usuário da API, ao fornecer o token do exame, possa ver os detalhes daquele exame no formato JSON, tal como está implementado no endpoint
`/tests`. A consulta deve ser feita na base de dados.

### Exemplo
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

#### Exibir na tela o resultado na pesquisa
Aqui não temos mais novidades. Você possui uma listagem de exames na tela e uma nova listagem (resultado da pesquisa por token) em mãos. Basta substituir a listagem atual pela nova valendo-se das mesmas ferramentas já utilizadas nas etapas anteriores.

### Lab 4: Criar endpoint para importar os dados do CSV de forma assíncrona

Com o Lab 1 completo, neste momento fazemos o import através de um script. Mas este script tem que ser executado por alguém developer ou admin do sistema.

Para melhorar isto, idealmente qualquer usuário da API poderia chamar um endpoint para atualizar os dados. Assim, o endpoint deveria aceitar um arquivo CSV dinâmico e importar os dados para o PostgreSQL.

Exemplo:
```bash
$ POST /import
```

#### Implementar endpoint para receber um CSV no HTTP request

Neste passo, devemos focar apenas em receber o CSV via HTTP e utilizar o mesmo código do script de import para popular o database.

* _Dica 1_: receber o conteúdo do CSV no HTTP request body ou então apenas o caminho para o CSV no servidor, o que for mais cômodo para você nesta fase
* _Dica 2_: pode usar a ferramenta `Postman` para testar os pedidos HTTP ou `curl`
* _Dica 3_: nesta fase, ainda fazer o processo "síncrono", ou seja, o usuário que chamar o endpoint `POST /import` deve ficar à espera

#### Executar o import do endpoint de forma assíncrona em background

Uma vez que fizemos o endpoint de `POST /import`, agora vamos focar numa implementação que permita que o usuário não fique _à espera_, ou seja, executar em um **background job**, mesmo o usuário sabendo que
não vai ficar pronto imediatamente. Neste caso, o processo de import fica pronto **eventualmente**.

* _Dica 1_: utilizar o `Sidekiq` para o processamento assíncrono
* _Dica 2_: o Sidekiq roda em um container separado da API
* _Dica 3_: subir um container para a visualização "Web" das filas do Sidekiq

### Lab Bônus: botão de "Importar CSV" na página Web (HTML)

Este lab é um *bônus* apenas. Não se preocupe pois havendo tempo, vamos abordar este assunto mais para o final das sessões.

* _Dica 1_: o botão ficará "estático" no HTML
* _Dica 2_: a ação do botão deverá fazer o pedido à API (`POST /import`), enviando um CSV no corpo do request

## Sessões e Dicas

Não temos uma data final para o término do laboratório, mas seria interessante que conseguíssemos concluir ao término da segunda semana, que é quando terminam as sessões.

* Lab 1: Docker, SQL e Testes
* Lab 2: Javascript, HTML e CSS
* Lab 3: Mais HTML, HTTP e SQL
* Lab 4: Background Job (Sidekiq)
* Lab bonus: Mais HTTP e HTML

#### Valorizamos documentação
Tente documentar o máximo possível sobre sua aplicação em arquivos `Markdown` (como este aqui por exemplo) ou então em páginas wiki.

Por se tratar de uma API separada do front-end, é extramemente importante que sejamos capazes de ler a documentação e conseguirmos fazer HTTP requests e analisar as respostas, tudo isso sem precisarmos perguntar como a aplicação deve se comportar.

Uma boa documentação é a *base* para a comunicação e boa saúde de um projeto de software.

#### Valorizamos testes
Testes são uma parte crucial no desenvolvimento de software. Se teu projeto não tem testes, não há garantias automatizadas de que ele vai continuar funcionando ao longo do tempo, à medida que mais código é adicionado nele.

### Dúvidas?
Em caso de dúvidas sobre qualquer um dos labs ou conteúdo das sessões, fique à vontade para conversar na ferramenta de comunicação do programa.