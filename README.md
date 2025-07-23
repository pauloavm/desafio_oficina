# Projeto de Banco de Dados para Oficina Mecânica

Este repositório contém um projeto completo de banco de dados para o gerenciamento de uma oficina mecânica. O projeto foi desenvolvido a partir de um esquema conceitual, traduzido para um modelo lógico relacional e implementado através de scripts SQL.

## Descrição do Projeto Lógico

O objetivo do banco de dados é centralizar e organizar todas as informações operacionais da oficina. O esquema permite gerenciar:

* **Clientes e seus Veículos:** Cadastro de clientes e os veículos que eles possuem.
* **Equipes e Mecânicos:** Organização dos funcionários em equipes, com suas especialidades.
* **Catálogo de Serviços e Peças:** Um registro de todos os serviços oferecidos (com valor de mão de obra) e das peças disponíveis em estoque (com valor unitário).
* **Ordens de Serviço (OS):** O núcleo do sistema, onde cada trabalho é registrado. Uma OS está associada a um veículo, a uma equipe responsável e contém os serviços a serem executados e as peças a serem utilizadas. O status da OS permite acompanhar o trabalho desde a avaliação inicial até a conclusão.

### Diagrama Entidade-Relacionamento (EER)

Abaixo, uma representação visual do esquema do banco de dados, mostrando as tabelas e seus relacionamentos.

```mermaid
erDiagram
    Clientes {
        int cliente_id PK
        varchar nome
        varchar telefone
        varchar email
    }

    Veiculos {
        int veiculo_id PK
        varchar placa UK
        varchar marca
        varchar modelo
        int ano
        int cliente_id FK
    }

    Equipes {
        int equipe_id PK
        varchar nome_equipe
    }

    Mecanicos {
        int mecanico_id PK
        varchar codigo UK
        varchar nome
        text endereco
        varchar especialidade
        int equipe_id FK
    }

    Servicos {
        int servico_id PK
        varchar nome_servico
        text descricao
        decimal valor_mao_obra
    }

    Pecas {
        int peca_id PK
        varchar nome_peca
        text descricao
        decimal valor_unitario
    }

    Ordens_Servico {
        int os_id PK
        varchar numero_os UK
        date data_emissao
        date data_prevista_conclusao
        date data_conclusao_real
        decimal valor_total
        enum status
        int veiculo_id FK
        int equipe_id FK
    }

    -- Relacionamentos
    Clientes ||--|{ Veiculos : possui
    Equipes ||--|{ Mecanicos : composta_por
    Ordens_Servico }o--|| Veiculos : para
    Ordens_Servico }o--|| Equipes : atribuida_a
    Ordens_Servico }o--o{ Servicos : "Ordens_Servico_Servicos"
    Ordens_Servico }o--o{ Pecas : "Ordens_Servico_Pecas"
