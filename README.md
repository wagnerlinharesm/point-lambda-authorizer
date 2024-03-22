# Point - Lambda Authorizer

## Introdução

Este projeto consiste em uma função Lambda na AWS que utiliza o serviço AWS Cognito para autenticação de usuários. A função é acionada por eventos HTTP e responde com códigos de status e mensagens JSON.

## Arquitetura

A arquitetura do projeto envolve os seguintes componentes:

- Função Lambda: Implementa a lógica de autenticação dos usuários.
- AWS Cognito: Serviço de autenticação e autorização para aplicativos da web e dispositivos móveis.
- Terraform: Utilizado para configurar e implantar recursos na AWS de forma automatizada e controlada.

## Fluxo de Trabalho

1. Um cliente faz uma solicitação HTTP para a função Lambda.
2. A função Lambda recebe a solicitação e verifica se o usuário existe no pool de usuários do AWS Cognito.
3. Se o usuário existir, a função tenta autenticar o usuário. Caso contrário, ela tenta registrar o usuário e, em seguida, autenticá-lo.
4. A função retorna uma resposta HTTP com o código de status apropriado e uma mensagem JSON indicando o resultado da operação.

## Configuração

Antes de implantar a função Lambda, é necessário configurar os seguintes recursos:

1. AWS Cognito User Pool: Um pool de usuários do AWS Cognito onde os usuários serão registrados e autenticados.
2. AWS IAM Role: Uma função IAM que permite que a função Lambda assuma o controle dos recursos necessários.
3. Lambda Function: A função Lambda que contém a lógica de autenticação dos usuários.

## Implantação

A implantação do projeto é realizada da seguinte maneira:

1. Os arquivos de configuração Terraform são preparados com as informações necessárias, como região da AWS e IDs de cliente e pool de usuários do AWS Cognito.
2. Os recursos são criados e implantados na AWS usando o Terraform.
3. A função Lambda é implantada na AWS, juntamente com sua configuração e código.

## Recursos

- Terraform: Utilizado para a automação da infraestrutura na AWS.
- AWS Lambda: Serviço de computação serverless da AWS.
- AWS Cognito: Serviço de autenticação e autorização da AWS.
- Python 3.11: Linguagem de programação utilizada para a implementação da lógica da função Lambda.
  
## Conclusão

Este projeto demonstra como criar uma função Lambda na AWS para autenticar usuários usando o AWS Cognito. Ele oferece uma solução segura e escalável para autenticação em aplicativos web e móveis, com a flexibilidade de ajustar e expandir conforme necessário.
