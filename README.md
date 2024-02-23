# TDD
api horse com sqlserver Desenvolvido no Rad Studio 10.2 Tokio

Configurar PARAMETROS.INI que fica na pasta do Executavel

Autenticacao da api usuario = tarefas password = ano+mes+dia exemplo: '20240209'

POST http://localhost:9000/v1/tarefas {"nometarefa":"desenvolvimento", "responsavel":"marcelo", "status":"A", "prioridade":1 }

PUT http://localhost:9000/v1/tarefas {"id":2, "status":"F" }

DELETE http://localhost:9000/v1/tarefas/2

GET http://localhost:9000/v1/tarefas

GET para estatistica http://localhost:9000/v1/tarefas/estatistica
