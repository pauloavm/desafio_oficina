-- 2. QUERIES SQL PARA ANÁLISE
-- ---------------------------------------------------------------------

-- Pergunta 1: Qual o valor total (peças + mão de obra) de uma Ordem de Serviço específica?
-- (Usa: SELECT, JOIN, SUM, WHERE, GROUP BY e atributos derivados)
SELECT
    os.numero_os,
    SUM(s.valor_mao_obra) AS ValorMaoDeObra,
    -- Expressão para gerar atributo derivado (Subtotal das Peças)
    SUM(p.valor_unitario * osp.quantidade) AS ValorPecas,
    -- Expressão para gerar atributo derivado (Valor Total da OS)
    (SUM(s.valor_mao_obra) + SUM(p.valor_unitario * osp.quantidade)) AS ValorTotalCalculado
FROM
    Ordens_Servico os
JOIN Ordens_Servico_Servicos oss ON os.os_id = oss.os_id
JOIN Servicos s ON oss.servico_id = s.servico_id
JOIN Ordens_Servico_Pecas osp ON os.os_id = osp.os_id
JOIN Pecas p ON osp.peca_id = p.peca_id
WHERE
    os.numero_os = 'OS-2025-003'
GROUP BY
    os.numero_os;

-- Explicação:
-- 1. A consulta calcula separadamente a soma da mão de obra e a soma do valor das peças (preço * quantidade).
-- 2. Ela então soma esses dois subtotais para gerar o `ValorTotalCalculado`.
-- 3. Utiliza `JOINs` para conectar a Ordem de Serviço com as tabelas de Serviços e Peças.
-- 4. O `WHERE` filtra para uma OS específica, e o `GROUP BY` agrupa os resultados para que as funções de agregação (`SUM`) funcionem corretamente.


-- Pergunta 2: Listar todas as Ordens de Serviço de um cliente, incluindo detalhes do veículo e status.
-- (Usa: SELECT, JOIN, WHERE, ORDER BY)
SELECT
    c.nome AS NomeCliente,
    v.placa AS PlacaVeiculo,
    v.marca,
    v.modelo,
    os.numero_os,
    os.data_emissao,
    os.status
FROM
    Ordens_Servico os
JOIN Veiculos v ON os.veiculo_id = v.veiculo_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
WHERE
    c.nome = 'Carlos Souza'
ORDER BY
    os.data_emissao DESC;

-- Explicação:
-- 1. Junta as tabelas `Ordens_Servico`, `Veiculos` e `Clientes` para obter uma visão completa.
-- 2. O `WHERE` filtra os resultados para mostrar apenas os de um cliente específico.
-- 3. O `ORDER BY` organiza as ordens da mais recente para a mais antiga.


-- Pergunta 3: Qual o serviço mais requisitado na oficina?
-- (Usa: SELECT, JOIN, COUNT, GROUP BY, ORDER BY)
SELECT
    s.nome_servico,
    COUNT(oss.servico_id) AS QuantidadeDeVezesSolicitado
FROM
    Ordens_Servico_Servicos oss
JOIN Servicos s ON oss.servico_id = s.servico_id
GROUP BY
    s.nome_servico
ORDER BY
    QuantidadeDeVezesSolicitado DESC;

-- Explicação:
-- 1. `COUNT(oss.servico_id)` conta quantas vezes cada serviço aparece na tabela de ligação.
-- 2. `GROUP BY s.nome_servico` agrupa essas contagens por nome do serviço.
-- 3. `ORDER BY ... DESC` ordena o resultado para mostrar o serviço mais popular no topo.


-- Pergunta 4: Qual equipe gerou um faturamento total (mão de obra) superior a R$ 300?
-- (Usa: JOIN, GROUP BY, HAVING, SUM)
SELECT
    e.nome_equipe,
    SUM(s.valor_mao_obra) AS FaturamentoMaoDeObra
FROM
    Ordens_Servico os
JOIN Equipes e ON os.equipe_id = e.equipe_id
JOIN Ordens_Servico_Servicos oss ON os.os_id = oss.os_id
JOIN Servicos s ON oss.servico_id = s.servico_id
-- Filtro opcional para considerar apenas OS concluídas
-- WHERE os.status = 'Concluída' 
GROUP BY
    e.nome_equipe
HAVING
    SUM(s.valor_mao_obra) > 300;

-- Explicação:
-- 1. `GROUP BY e.nome_equipe`: Agrupa todas as receitas de mão de obra por equipe.
-- 2. `SUM(s.valor_mao_obra)`: Calcula o total faturado por cada equipe.
-- 3. `HAVING`: Após o agrupamento, o `HAVING` filtra os resultados, mostrando apenas as equipes cujo faturamento total é maior que o valor especificado (300).