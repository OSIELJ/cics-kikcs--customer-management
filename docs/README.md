# Projeto Consulta e Atualização de Clientes em CICS

Projeto desenvolvido em COBOL no ambiente **TK5/MVS 3.8j**, utilizando **TN3270** e **KICKS** para simular ambiente CICS.

O sistema implementa uma aplicação online para consulta e atualização de clientes armazenados em um arquivo VSAM. A transação `CLIE` executa o programa `CADCLI`, que interage com uma tela BMS e com o arquivo `CLIENTES`.

---

## Demonstração

### 1. Consultando um cliente (PF5)
![Consultando um cliente](docs/demo-consulta.gif)
<img width="722" height="372" alt="1_ TK5 - TN3270 Plus 2026-06-26 04-37-53" src="https://github.com/user-attachments/assets/5975276e-6372-4636-a52c-7fbc1a8f3bcf" />

### 2. Editando telefone e cidade (PF6)
![Editando telefone e cidade](docs/demo-edicao.gif)
<img width="722" height="372" alt="1_ TK5 - TN3270 Plus 2026-06-26 04-39-46" src="https://github.com/user-attachments/assets/cd2b39a4-adf0-4f36-9bcf-ea968d0a0280" />

### 3. Confirmando a alteração — novo acesso ao KICKS
![Confirmando a alteração](docs/demo-confirmacao.gif)
<img width="722" height="372" alt="1_ TK5 - TN3270 Plus 2026-06-26 04-40-46" src="https://github.com/user-attachments/assets/684c2cdb-1497-441a-8f46-bb36cc38453c" />


---

## Tela do Sistema

><img width="1914" height="1029" alt="Captura de tela 2026-06-26 044149" src="https://github.com/user-attachments/assets/e51dff78-0981-4d68-8fca-35da5eeaa56d" />



---

## Lógica de Funcionamento

Ao executar a transação `CLIE`, o sistema apresenta a tela de consulta de clientes.

O usuário informa o código do cliente e utiliza as teclas de função para consultar, alterar ou sair da transação.

* **PF5** consulta o cliente pelo código informado.
* **PF6** atualiza somente telefone e cidade.
* **PF3** encerra a transação e retorna ao terminal do KICKS.

---

## Em Funcionamento no TK5 com o KICKS com testes das funcionalidades

> *Coloque aqui um print ou gif do sistema em execução*

---

## Fluxograma PF5 - Consulta

```mermaid
flowchart TD
    A[Usuário informa o código] --> B[Pressiona PF5]
    B --> C{Código informado?}
    C -- Não --> D[Exibe: INFORME O CODIGO.]
    D --> Z[Mostra a tela novamente]
    C -- Sim --> E[READ no VSAM CLIENTES]
    E --> F{Cliente encontrado?}
    F -- Sim --> G[Move nome, telefone e cidade para a tela]
    G --> H[Exibe: CLIENTE ENCONTRADO.]
    H --> Z
    F -- Não --> I[Limpa nome, telefone e cidade]
    I --> J[Exibe: CLIENTE NAO ENCONTRADO.]
    J --> Z
    F -- Erro --> K[Exibe: ERRO NA CONSULTA.]
    K --> Z
```

---

## Fluxograma PF6 - Atualização

```mermaid
flowchart TD
    A[Usuário informa código, telefone e cidade] --> B[Pressiona PF6]
    B --> C{Código informado?}
    C -- Não --> D[Exibe: INFORME O CODIGO.]
    D --> Z[Mostra a tela novamente]
    C -- Sim --> E[READ UPDATE no VSAM CLIENTES]
    E --> F{Cliente encontrado?}
    F -- Não --> G[Exibe: CLIENTE NAO ENCONTRADO.]
    G --> Z
    F -- Erro --> H[Exibe: ERRO NA CONSULTA.]
    H --> Z
    F -- Sim --> I[Atualiza telefone e cidade no registro]
    I --> J[REWRITE no VSAM CLIENTES]
    J --> K{Gravação concluída?}
    K -- Sim --> L[Exibe: ALTERACAO REALIZADA.]
    L --> Z
    K -- Não --> M[Exibe: ERRO AO ATUALIZAR.]
    M --> Z
```

---

## Arquivos do Projeto

```text
src/CADCLI.cbl      Programa COBOL executado pela transação CLIE
src/MAPSCA.bms      Fonte do mapa BMS da tela
jcl/DEFCLI.jcl      JCL para criar e carregar o arquivo VSAM CLIENTES
jcl/MAPP7.jcl       JCL para gerar o mapa BMS
jcl/BUILDP7.jcl     JCL para compilar e linkar o programa COBOL
jcl/ASMCLIE.jcl     JCL para registrar a transação nas tabelas do KICKS
```

---

### Configuração de apoio usada no KICKS

Para a aplicação funcionar no ambiente KICKS, foram necessários mais alguns arquivos configurados:

```text
PCT  -> A transação CLIE apontando para o programa CADCLI
PPT  -> Programa CADCLI e mapset MAPSCA
FCT  -> Arquivo VSAM CLIENTES
```

Essas configurações foram montadas via Assembler (job ASMCLIE) para registrar as tabelas binárias do KICKS (KIKPCTB$, KIKPPTB$, KIKFCTB$).

---

## Comandos CICS/KICKS Utilizados

```text
SEND      Envia a tela BMS para o terminal
RECEIVE   Recebe os campos preenchidos pelo usuário
RETURN    Encerra a transação
READ      Consulta o cliente no VSAM
REWRITE   Atualiza o registro no VSAM
```

---

## Objetivo do Projeto

Este projeto tem como objetivo praticar desenvolvimento COBOL online em ambiente mainframe, utilizando transações CICS/KICKS, mapa BMS, interação com terminal 3270, consulta e atualização de registros VSAM. A aplicação foi executada com sucesso no ambiente TK5/KICKS, permitindo consultar clientes e persistir alterações de telefone e cidade.
