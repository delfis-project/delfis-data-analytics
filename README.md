# Aplicativo para Redução do Risco de Alzheimer

## Descrição

Este projeto é um aplicativo projetado para ajudar a reduzir o risco de Alzheimer e outras doenças cognitivas através de jogos interativos, como jogo da velha, sudoku e problemas matemáticos. A aplicação se concentra em oferecer atividades diárias que estimulem a mente e promovam a saúde cognitiva.

## Funcionalidades

- **RPA para Análise de Dados**: Implementação de três processos de automação para análise de dados:
  - **Verificação de Entrada Diária do Usuário (Streak)**: Monitora a frequência diária de participação do usuário.
  - **Transferência de Dados**: Automação de transferências de dados entre bancos de dados.
  - **Atualização da Base de Dados do Power BI**: Atualiza automaticamente os dados no Power BI para relatórios e visualizações.
- **Treinamento de IA**: Notebook em jupyter que treina 3 modelos de IA (KNN, Naive Bayes, Tree Decision)
- **Formulário de Previsão**: Um formulário que tenta prever se uma pessoa é um possível cliente com base em dados de entrada.

## Implantação

O aplicativo foi implantado nas seguintes plataformas:

- **AWS**: Utilizando serviços da AWS para hospedar a aplicação e os processos de backend.
- **Render**: Hospedagem do formulário que coleta dados para prever potenciais clientes.

## Tecnologias Utilizadas

- Python
- Flask
- Power BI
- AWS (Amazon Web Services)
- Pandas
- Psycopg2
- SqlAlchemy
- Sklearn
- Joblib
- Pickle
- SQL
