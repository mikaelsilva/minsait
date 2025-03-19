# minsait

## Teste técnico para Engenheiro de Dados


## Desenvolvimento

- Organização do Git
  - **data**, com os dados passados para o teste;
  - **img** contendo as imagens para documentação do projeto;
  - **notebooks**, contendo todos os notebooks utilizados;
  - **sql** contendo os scripts utilizados para criar o dashboard no Metabase;
  - **tables** contendo os arquivos **.csv** de saída dos notebooks;
  - **database.db** para utilizar como banco no metabase contendo as tabelas **.csv** geradas
  - **dashboard** em pdf gerado no metabase;
  - E por fim o **docker-compose** utilizado para iniciar o metabase localmente e realizar as queries.
- Notebooks - Overview
  - O notebook overview foi utilizado para se ter uma visão geral dos arquivos e entender um pouco sobre suas caracteristicas, dentro do notebook tem algumas observações, que vou trazer aqui para organizar melhor a documentação;
  - Interessante notar que os pacientes (cada arquivo), possuem tipos e quantidades diferentes de **RESOURCES**, então definir um layout unico para leitura de todos os arquivos, não parece ser tão interessante nesse primeiro momento já que isso poderia comprometer algumas informações importantes que poderiam ser **perdidas** nesse processo.
  - Patient
    - Quando se acessa o RESOURCE, já no mesmo nível do resourceType onde conseguimos identificar que o tipo é PATIENT, conseguimos também acessar o campo GENDER, contendo a informação principal do genero do paciente;
    - Também é possivel acessar facilmente a informação de BIRTHDATE, o que é bastante interessante já que é possivel analisar a idade dos pacientes;
    - Com a informação de ID é possivel relacionar outras informações de outros resourceTypes que fazem referência ao paciente;
    - Os demais campos [extension, identifier, name, telecom, address] também são interessantes para se analisar, mas como são mais volateis, é interessante se concentrar neles em etapas posteriores.
  - Condition:
    - Novamente, olhando para o mesmo nível de informações que resourceType, conseguimos acessar a informação de ID da requisição da condição e informações interessantes de data, como onsetDateTime | abatementDateTime | recordedDate;
    - Além disso, no campo CODE, conseguimos acessar a informação mais importante (em relação a uma das perguntas do teste), para conseguir encontrar quais são as condições mais comuns. Esse campo CODE, possui um subcampo chamado CODING, que faz ser possivel de fato conseguirmos o CODE da condição e o DISPLAY (TEXT) dela;
    - Também conseguimos acessar dois campos interessantes dentro desse resourceType, o de clinicalStatus e de verificationStatus;
    - O campo SUBJECT também é interessante, já que ele faz referência ao ID do PACIENTE;
    - As informações restantes, podem ser analisadas posteriormente.
  - Medication Request:
    - Na estrutura do resourceType do tipo MedicationRequest, algumas informações já podem ser acessadas diretamente, como é o caso de id | status | intent | authoredOn.
    - No caso, como sugerido no README do teste, para conseguir a informação relacionada ao nome dos medicamentes, é necessário acessar medicationCodeableConcept.text. Porém, interesasnte notar que dentro do campo CODING, é possivel conseguir ambas as informações CODE | DISPLAY (TEXT), o que pode ajudar ainda mais em analises futuras já que o codigo do medicamento pode ajudar a relacionar informações entre tabelas;
    - Mais duas informações são interessantes de serem acessadas nesse primeiro momento. O campo SUBJECT que faz referência ao ID do PACIENTE e o campo REQUESTER, que indica o médico que fez a solicitação;
    - As outras informações (principalmente relacionada a dosagem, que nem todos possuem esse tipo de informação), também são interessantes de se analisar em etapas posteriores.

- Notebooks (**PATIENT**, **CONDITION**, **MEDICATION_REQUEST**)
  1. Os notebooks apresentam algumas semelhanças entre si;
  1. É feito uma leitura de todos os arquivos;
  1. Uma operação de **explode** na coluna de **entry** onde os dados estão listados, para que sejam separados em outras linhas no dataframe;
  1. É realizado uma filtragem relacionada ao seu tipo de dado **resource.resourceType** Patient, Condition ou MedicationRequest;
  1. Depois o processamento e a transformação dos dados de acordo com as informações de cada tipo de tabela que será gerada;
  1. Condition e MedicationRequest possuem uma função auxiliar para remover alguns valores dos campos que possuem o ID do Subject ou do Requester;
  1. Salvamento do resultado em  **.csv**.

- Docker e Metabase
  - Foi utilizado o Metabase como ferramenta de visualização dos dados e criação das queries para gerar um dashboard ou analise geral por Analistas ou Cientistas de dados.
  - Foi utilizado o docker-compose.yaml para montar o volume local do **database.db** (sqlite que recebeu as tabelas .csv com a partir do notebook **csv_to_sqlite**) e a rota do metabase.
  - Imagens da inicialização do metabase com docker ![Imagem](/img/1_metabase_docker.PNG) banco minsait onde estão os dados para consulta ![Imagem2](/img/2_metabase_bancos_de_dados.PNG)
  - Imagens relacionadas as tabelas, sendo visualizadas no metabase *detalhe sobre o tempo para requisição dos dados*;
  - Patient![Imagem3](/img/3_patient.PNG) Condition ![Imagem4](/img/4_condition.PNG) Medication Request ![Imagem5](/img/5_medication_request.PNG)
  - Visão geral do dashboard criado ![Dashboard](/img/6_dashboard.PNG)


- Conclusão geral
    - Nesse momento, os principais campos, que podem ajudar a relacionar as tabelas entre si (Patient, MedicationRequest e Condition), foram coletados, além de informações que cada tabela individualmente pode ajudar a gerar insights e outras informações interessantes sobre o paciente e sua condição e medicação durante os registros médicos;
    - Separando as tabelas em Patient, MedicationRequest e Condition, é possivel distribuir melhor o processamento e o código para criar as tabelas para analises. O processamento então pode acontecer independente entre eles, o que ajuda a manter as tabelas atualizadas de acordo com o fluxo de informação de cada resourceType;
    - Em cada fluxo de processamento, ao final, o salvamento da tabela final acontece em um arquivo **.CSV**, e depois é rodado outro notebook para passar esses dados para um sqlite chamado **database.db**;
    - Esse banco é utilizado para ser o DB do Metabase, e será *referenciado via docker-compose*, dessa forma, é possivel analisar as tabelas que foram geradas, consequentemente, respondendo as perguntas solicitadas no projeto via SQL.
    - A próxima e última imagem mostra um fluxograma com os processos explicados acima e como foi pensado nesse primeiro momento a estruturação do projeto para o teste.

![geral](/img/minsait.png)