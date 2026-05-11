# Richard Fretes

Sistema web de gestão logística para controle de fretes, clientes, motoristas, veículos, endereços, ocorrências operacionais, manutenções e relatórios em PDF.

O projeto foi construído com `Java 8`, `Servlets + JSP`, `Gradle`, `PostgreSQL` e `JasperReports`, com execução web via `WAR` e configuração de desenvolvimento com `Gretty/Tomcat 9`.

## Visão geral

O Richard Fretes centraliza a operação de transporte em um único sistema. Pela estrutura atual do código, o projeto cobre:

- autenticação por login e cadastro via API interna;
- painel com visão administrativa e visão por cliente;
- cadastro e gestão de clientes;
- cadastro e gestão de endereços vinculados aos clientes;
- cadastro e gestão de motoristas;
- cadastro e gestão da frota;
- cadastro, edição, detalhamento e acompanhamento de fretes;
- registro de ocorrências de frete com foto de evidência;
- controle de manutenção de veículos;
- geração de relatórios PDF com JasperReports.

## Stack do projeto

- `Java 8`
- `Gradle`
- `WAR`
- `Gretty 3.0.6`
- `Tomcat 9`
- `JSTL`
- `PostgreSQL`
- `Jackson Databind`
- `JasperReports`

## Variáveis de ambiente

A conexão com o banco depende de 3 variáveis obrigatórias, lidas em [`ConnectionFactory.java`](/home/estagiario3/Documentos/Richard_Fretes/src/main/java/br/com/connection/ConnectionFactory.java:1).

| Variável | Obrigatória | Descrição | Exemplo |
| --- | --- | --- | --- |
| `RICHARD_FRETES_DB_URL` | Sim | URL JDBC do PostgreSQL | `jdbc:postgresql://localhost:5432/richard_fretes` |
| `RICHARD_FRETES_DB_USER` | Sim | Usuário do banco | `postgres` |
| `RICHARD_FRETES_DB_PASSWORD` | Sim | Senha do banco | `postgres` |

Exemplo no Linux/macOS:

```bash
export RICHARD_FRETES_DB_URL="jdbc:postgresql://localhost:5432/richard_fretes"
export RICHARD_FRETES_DB_USER="postgres"
export RICHARD_FRETES_DB_PASSWORD="postgres"
```

Observações:

- o projeto não usa arquivo `.env`; as variáveis são lidas diretamente do ambiente do processo Java;
- se alguma delas não estiver definida, a aplicação falha na abertura da conexão;
- não encontrei outras variáveis de ambiente obrigatórias no código atual.

## Pré-requisitos

- `JDK 8`
- `PostgreSQL`
- acesso às dependências do Gradle na primeira execução do wrapper

## Como subir o projeto

1. Crie um banco PostgreSQL, por exemplo `richard_fretes`.
2. Configure as variáveis de ambiente listadas acima.
3. Execute os scripts SQL da pasta `db` na ordem recomendada.
4. Suba a aplicação com Gradle.

Fluxo comum com o wrapper:

```bash
./gradlew appRun
```

Outros comandos úteis do build:

```bash
./gradlew build
./gradlew war
```

No `build.gradle`, o contexto web está configurado como `/RichardFretes`, então o acesso local costuma seguir este padrão:

```text
http://localhost:8080/RichardFretes/login
```

## Banco de dados

A pasta [`db`](/home/estagiario3/Documentos/Richard_Fretes/db) concentra a criação das tabelas, a carga inicial de dados e a sincronização de sequences.

### Ordem recomendada de execução

1. `db/createTableCliente.sql`
2. `db/createTableEndereco.sql`
3. `db/createTableMotorista.sql`
4. `db/createTableVeiculo.sql`
5. `db/createTableFrete.sql`
6. `db/createTableOcorrencia.sql`
7. `db/createTableManutencaoVeiculo.sql`
8. `db/createTableUsuario.sql`
9. `db/seed_dados_bo.sql`
10. `db/sincronizar_sequences.sql` somente se você fizer inserts manuais depois da seed

### O que faz cada script

`createTableCliente.sql`

- cria o tipo `tipo_entrega_enum`;
- cria a tabela `cliente`.

Atenção:

- esse arquivo hoje termina com vários `DROP TABLE IF EXISTS`, inclusive de `cliente`;
- revise esse script antes de executar em ambiente real, porque no estado atual ele mistura criação com remoção de tabelas.

`createTableEndereco.sql`

- cria a tabela `endereco`;
- adiciona FK para `cliente`;
- cria índice por `cliente_id`.

`createTableMotorista.sql`

- cria enums de CNH, vínculo, PIX e status;
- cria a tabela `motorista`;
- relaciona o motorista a um cliente.

`createTableVeiculo.sql`

- cria o enum de status do veículo;
- cria a tabela `veiculo`;
- relaciona veículo com cliente e motorista principal;
- cria índice por placa.

`createTableFrete.sql`

- cria o enum de status do frete;
- cria a tabela principal `frete`;
- relaciona remetente, destinatário, endereços, motorista e veículo;
- cria índices por número, status e data de emissão.

`createTableOcorrencia.sql`

- cria o enum de tipo de ocorrência;
- cria a tabela `ocorrencia_frete`;
- cria vínculo com `frete` usando `ON DELETE CASCADE`;
- permite latitude, longitude, recebedor e URL de evidência.

`createTableManutencaoVeiculo.sql`

- cria enums de tipo e status de manutenção;
- cria a tabela `manutencao_veiculo`;
- vincula a manutenção ao veículo com `ON DELETE CASCADE`;
- cria índices de apoio para listagens e relatórios.

`createTableUsuario.sql`

- cria a tabela `usuario`;
- define campos de login, permissão administrativa, vínculo com cliente e ativo/inativo;
- contém `UPDATE`s para marcar o usuário `id = 1` como admin e associar o usuário `id = 2` ao cliente `id = 1`.

Observação:

- esses `UPDATE`s só fazem sentido se já existirem registros correspondentes.

`seed_dados_bo.sql`

- popula `cliente`, `endereco`, `usuario`, `motorista`, `veiculo`, `frete` e `ocorrencia_frete`;
- prepara um cenário funcional para testar o BO e a navegação do sistema;
- sincroniza as sequences ao final com `setval(...)`.

Observações importantes:

- o script não insere dados iniciais em `manutencao_veiculo`;
- todos os usuários seed entram com senha `123456`;
- essas senhas foram colocadas em texto puro de propósito para o fluxo de migração automática no login.

`sincronizar_sequences.sql`

- recalcula as sequences de todas as tabelas principais;
- é útil depois de imports manuais, ajustes de IDs ou cargas parciais.

## Autenticação e usuários seed

O login e cadastro são feitos pela API interna em [`AuthApiServlet.java`](/home/estagiario3/Documentos/Richard_Fretes/src/main/java/br/com/auth/AuthApiServlet.java:1):

- `POST /RichardFretes/api/auth/register`
- `POST /RichardFretes/api/auth/login`

A sessão autenticada fica em `usuarioAutenticado` e hoje tem timeout de `30 minutos`.

Pontos importantes do fluxo atual:

- novos usuários são gravados com hash PBKDF2;
- usuários da seed entram com `123456`;
- ao autenticar um usuário legado, o sistema regrava a senha em hash automaticamente.

Exemplos da seed:

- admin: `luan@email.com` / `123456`
- cliente: `mariana.costa@atlasdist.com.br` / `123456`

## Módulos do sistema

### Operação

- `fretes`
- `ocorrencias`
- `enderecos`

### Cadastros

- `clientes`
- `motoristas`
- `veiculos`
- `usuarios/minha conta`

### Manutenção

- `manutencoes`

### Relatórios PDF

- `/RichardFretes/relatorios/fretes-abertos`
- `/RichardFretes/relatorios/romaneio-carga`
- `/RichardFretes/relatorios/manutencoes-veiculos`

Os relatórios são compilados em tempo de execução a partir dos arquivos `.jrxml` em [`src/main/webapp/reports`](/home/estagiario3/Documentos/Richard_Fretes/src/main/webapp/reports).

## Uploads de comprovante

Ao registrar ocorrência com evidência de imagem, a aplicação cria automaticamente a pasta:

```text
/uploads/comprovantes
```

dentro do contexto da aplicação e salva arquivos de imagem nela. Esse fluxo está em [`OcorrenciaFreteServlet.java`](/home/estagiario3/Documentos/Richard_Fretes/src/main/java/br/com/ocorrenciafrete/OcorrenciaFreteServlet.java:1).

## Estrutura principal

```text
src/main/java       código Java
src/main/webapp     JSP, CSS, JS, imagens e relatórios
db                  scripts SQL
build.gradle        build e configuração do Gretty/Tomcat
```

## Observações finais

- a aplicação usa PostgreSQL e depende dessas variáveis desde a primeira conexão;
- existe distinção entre usuário administrador e usuário vinculado a cliente;
- parte do comportamento do sistema já está preparada para uso com dados de demonstração via `seed_dados_bo.sql`;
- antes de rodar os scripts SQL em produção, vale revisar especialmente `createTableCliente.sql` e `createTableUsuario.sql`.
