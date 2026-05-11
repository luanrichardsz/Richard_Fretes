BEGIN;

-- Seed com dados realistas e relacionamentos consistentes para uso no BO.
-- Todos os usuarios possuem a senha 123456 em texto puro para migracao automatica no login.

INSERT INTO cliente (
    id,
    razao_social,
    nome_fantasia,
    documento,
    inscricao_estadual,
    tipo_entrega,
    email,
    telefone,
    ativo,
    criado_em
) VALUES
    (1, 'Atlas Distribuicao Paulista Ltda', 'Atlas Distribuicao', '11222333000181', '110042490114', 'AMBOS', 'financeiro@atlasdistribuicao.com.br', '11987456321', TRUE, '2026-01-05 09:10:00'),
    (2, 'Verde Campo Alimentos Ltda', 'Verde Campo', '22333444000181', '244556780119', 'AMBOS', 'contato@verdecampoalimentos.com.br', '19996541230', TRUE, '2026-01-06 10:20:00'),
    (3, 'Costa Azul Comercio Atacadista Ltda', 'Costa Azul Atacado', '33444555000181', '870114320001', 'DESTINATARIO', 'expedicao@costaazulatacado.com.br', '21994321876', TRUE, '2026-01-07 11:15:00'),
    (4, 'Minas Farma Distribuidora Ltda', 'Minas Farma', '44555666000181', '0623456789012', 'AMBOS', 'operacao@minasfarma.com.br', '31995437788', TRUE, '2026-01-08 08:45:00'),
    (5, 'Serra Sul Materiais Ltda', 'Serra Sul', '55666777000181', '9056781200', 'REMETENTE', 'logistica@serrasulmateriais.com.br', '41991827364', TRUE, '2026-01-09 14:05:00'),
    (6, 'Pampa Bebidas Industriais Ltda', 'Pampa Bebidas', '66777888000181', '0965432108', 'AMBOS', 'fiscal@pampabebidas.com.br', '51991234567', TRUE, '2026-01-10 16:30:00'),
    (7, 'Bahia Agro Exportacao Ltda', 'Bahia Agro', '77888999000181', '123456789', 'REMETENTE', 'comercial@bahiaagro.com.br', '71993456789', TRUE, '2026-01-11 13:25:00'),
    (8, 'Nordeste Hospitalar Ltda', 'Nordeste Hospitalar', '88999000000198', '0321654987', 'DESTINATARIO', 'suprimentos@nordestehospitalar.com.br', '81995673412', TRUE, '2026-01-12 09:55:00'),
    (9, 'Ceara Frutas Congeladas Ltda', 'Ceara Frutas', '99000111000165', '060123456', 'AMBOS', 'vendas@cearafrutas.com.br', '85994561234', TRUE, '2026-01-13 15:40:00'),
    (10, 'Centro Oeste Equipamentos Ltda', 'Centro Oeste Equipamentos', '12131415000183', '104567890123', 'AMBOS', 'atendimento@centrooesteequip.com.br', '62994678123', TRUE, '2026-01-14 10:05:00');

INSERT INTO endereco (
    id,
    cliente_id,
    cep,
    logradouro,
    numero,
    complemento,
    bairro,
    municipio,
    codigo_ibge,
    uf,
    ponto_referencia
) VALUES
    (1, 1, '04538132', 'Avenida Engenheiro Luis Carlos Berrini', '1450', 'Conjunto 82', 'Cidade Moncoes', 'Sao Paulo', '3550308', 'SP', 'Proximo a ponte Estaiada'),
    (2, 1, '07095010', 'Rodovia Presidente Dutra', '214', 'Galpao 4', 'Cumbica', 'Guarulhos', '3518800', 'SP', 'Ao lado do terminal de cargas'),
    (3, 2, '13035005', 'Rua Jose Paulino', '1347', 'Armazem A', 'Centro', 'Campinas', '3509502', 'SP', 'Esquina com a rua Barao de Jaguara'),
    (4, 2, '13209510', 'Avenida Antonio Frederico Ozanan', '6000', 'Bloco B', 'Vila Rio Branco', 'Jundiai', '3525904', 'SP', 'Ao lado do atacadista'),
    (5, 3, '20040002', 'Rua Primeiro de Marco', '23', 'Sala 504', 'Centro', 'Rio de Janeiro', '3304557', 'RJ', 'Proximo a Praca XV'),
    (6, 3, '25071000', 'Rodovia Washington Luiz', '1800', 'Galpao 9', 'Jardim Gramacho', 'Duque de Caxias', '3301702', 'RJ', 'Km 113 sentido Serra'),
    (7, 4, '30130010', 'Avenida Afonso Pena', '1500', 'Andar 7', 'Centro', 'Belo Horizonte', '3106200', 'MG', 'Em frente ao parque municipal'),
    (8, 4, '32210110', 'Rua Jose Faria da Rocha', '3250', 'Deposito 2', 'Eldorado', 'Contagem', '3118601', 'MG', 'Proximo ao Big Shopping'),
    (9, 5, '80010000', 'Rua Emiliano Perneta', '310', 'Loja 12', 'Centro', 'Curitiba', '4106902', 'PR', 'Ao lado da praca Osorio'),
    (10, 5, '83005200', 'Avenida Rui Barbosa', '7281', 'Galpao 3', 'Afonso Pena', 'Sao Jose dos Pinhais', '4125506', 'PR', 'Proximo ao aeroporto'),
    (11, 6, '90010000', 'Avenida Voluntarios da Patria', '2200', 'CD 1', 'Navegantes', 'Porto Alegre', '4314902', 'RS', 'Em frente ao porto seco'),
    (12, 6, '92010010', 'Rua Guilherme Schell', '6750', 'Unidade Canoas', 'Centro', 'Canoas', '4304606', 'RS', 'Proximo ao viaduto da Boqueirao'),
    (13, 7, '40015000', 'Avenida Estados Unidos', '397', 'Sala 1203', 'Comercio', 'Salvador', '2927408', 'BA', 'Predio comercial da orla portuaria'),
    (14, 7, '44052002', 'Avenida Eduardo Froes da Mota', '1850', 'Galpao C', 'Tomba', 'Feira de Santana', '2910800', 'BA', 'Anel de contorno, sentido BR-116'),
    (15, 8, '50030000', 'Rua da Moeda', '71', 'Bloco Administrativo', 'Recife', 'Recife', '2611606', 'PE', 'No bairro do Recife Antigo'),
    (16, 8, '54315010', 'Avenida General Barreto de Menezes', '1648', 'Galpao 6', 'Prazeres', 'Jaboatao dos Guararapes', '2607901', 'PE', 'Ao lado do mercado das mangueiras'),
    (17, 9, '60060080', 'Avenida Santos Dumont', '2122', 'Loja 5', 'Aldeota', 'Fortaleza', '2304400', 'CE', 'Perto do shopping Aldeota'),
    (18, 9, '61900180', 'Avenida Parque Central', '1200', 'Camara Fria 2', 'Distrito Industrial I', 'Maracanau', '2307650', 'CE', 'Condominio logistico do distrito'),
    (19, 10, '74015020', 'Avenida Anhanguera', '5300', 'Sala 18', 'Setor Central', 'Goiania', '5208707', 'GO', 'Em frente ao terminal Praca A'),
    (20, 10, '74935010', 'Avenida Rio Verde', '8500', 'Patio 1', 'Vila Brasilia', 'Aparecida de Goiania', '5201405', 'GO', 'Ao lado do centro automotivo');

INSERT INTO usuario (
    id,
    usuario,
    email,
    senha,
    is_administrador,
    cliente_id,
    ativo
) VALUES
    (1, 'Luan Fretes', 'luan@email.com', '123456', TRUE, 10, TRUE),
    (2, 'Mariana Costa', 'mariana.costa@atlasdist.com.br', '123456', FALSE, 1, TRUE),
    (3, 'Rafael Lima', 'rafael.lima@verdecampo.com.br', '123456', FALSE, 2, TRUE),
    (4, 'Patricia Gomes', 'patricia.gomes@costaazul.com.br', '123456', FALSE, 3, TRUE),
    (5, 'Vinicius Rocha', 'vinicius.rocha@minasfarma.com.br', '123456', FALSE, 4, TRUE),
    (6, 'Camila Duarte', 'camila.duarte@serrasul.com.br', '123456', FALSE, 5, TRUE),
    (7, 'Eduardo Pires', 'eduardo.pires@pampabebidas.com.br', '123456', FALSE, 6, TRUE),
    (8, 'Juliana Nunes', 'juliana.nunes@bahiaagro.com.br', '123456', FALSE, 7, TRUE),
    (9, 'Tiago Moura', 'tiago.moura@nordestehospitalar.com.br', '123456', FALSE, 8, TRUE),
    (10, 'Beatriz Melo', 'beatriz.melo@cearafrutas.com.br', '123456', FALSE, 9, TRUE);

INSERT INTO motorista (
    id,
    nome_completo,
    rg,
    cpf,
    data_nascimento,
    telefone,
    nome_emergencia,
    telefone_emergencia,
    parentesco_emergencia,
    numero_cnh,
    categoria_cnh,
    validade_cnh,
    validade_toxicologico,
    tipo_vinculo,
    chave_pix,
    tipo_pix,
    status,
    adicionado_em,
    cliente_id
) VALUES
    (1, 'Carlos Eduardo Monteiro', '245678912', '12345678909', '1984-03-14', '11988123456', 'Sonia Monteiro', '11997654321', 'Mae', '51627384901', 'E', '2028-08-20', '2027-11-30', 'FUNCIONARIO', 'carlos.monteiro@atlasdist.com.br', 'EMAIL', 'ATIVO', '2026-02-01 08:00:00', 1),
    (2, 'Ana Paula Ribeiro', '318765432', '98765432100', '1987-07-22', '19998234567', 'Marcos Ribeiro', '19997112233', 'Irmao', '62738495012', 'D', '2028-09-15', '2027-10-10', 'FUNCIONARIO', 'ana.ribeiro@verdecampo.com.br', 'EMAIL', 'ATIVO', '2026-02-02 08:15:00', 2),
    (3, 'Bruno Henrique Castro', '402345678', '11144477735', '1982-11-05', '21997345678', 'Lucia Castro', '21996445566', 'Esposa', '73849506123', 'E', '2029-01-18', '2028-04-25', 'AGREGADO', 'bruno.castro@costaazul.com.br', 'EMAIL', 'ATIVO', '2026-02-03 08:30:00', 3),
    (4, 'Diego Martins Souza', '517894321', '22233344405', '1979-05-29', '31996456789', 'Priscila Souza', '31995544332', 'Esposa', '84950617234', 'E', '2028-12-12', '2027-12-01', 'FUNCIONARIO', 'diego.souza@minasfarma.com.br', 'EMAIL', 'ATIVO', '2026-02-04 08:45:00', 4),
    (5, 'Fernanda Lopes Araujo', '628901234', '31415926590', '1989-01-17', '41995567890', 'Joana Lopes', '41994433221', 'Mae', '95061728345', 'D', '2028-06-10', '2027-09-14', 'FUNCIONARIO', 'fernanda.araujo@serrasul.com.br', 'EMAIL', 'ATIVO', '2026-02-05 09:00:00', 5),
    (6, 'Gabriel Tavares Pinto', '734512890', '27182818205', '1985-09-09', '51994678901', 'Claudio Pinto', '51993322110', 'Pai', '06172839456', 'E', '2029-03-07', '2028-02-18', 'TERCEIRO', 'gabriel.pinto@pampabebidas.com.br', 'EMAIL', 'ATIVO', '2026-02-06 09:15:00', 6),
    (7, 'Helena Moura Santana', '845623901', '13579135759', '1990-12-11', '71993789012', 'Rita Santana', '71992233445', 'Mae', '17283940567', 'E', '2028-10-28', '2027-08-20', 'AGREGADO', 'helena.santana@bahiaagro.com.br', 'EMAIL', 'ATIVO', '2026-02-07 09:30:00', 7),
    (8, 'Igor Almeida Freitas', '956734012', '24680246804', '1983-04-03', '81992890123', 'Marina Freitas', '81991777889', 'Esposa', '28394051678', 'D', '2028-11-16', '2027-11-01', 'FUNCIONARIO', 'igor.freitas@nordestehospitalar.com.br', 'EMAIL', 'ATIVO', '2026-02-08 09:45:00', 8),
    (9, 'Joao Victor Barros', '167845123', '35795145637', '1988-08-26', '85991901234', 'Paulo Barros', '85990888776', 'Pai', '39405162789', 'D', '2028-07-22', '2027-12-19', 'FUNCIONARIO', 'joao.barros@cearafrutas.com.br', 'EMAIL', 'ATIVO', '2026-02-09 10:00:00', 9),
    (10, 'Karen Cristina Nogueira', '278956234', '86420975310', '1991-02-19', '62991012345', 'Jose Nogueira', '62999877665', 'Pai', '40516273890', 'E', '2029-02-14', '2028-01-28', 'FUNCIONARIO', 'karen.nogueira@centrooesteequip.com.br', 'EMAIL', 'ATIVO', '2026-02-10 10:15:00', 10);

INSERT INTO veiculo (
    id,
    placa,
    renavam,
    rntrc,
    ano_fabricacao,
    ano_modelo,
    tipo,
    tipo_outros,
    quantidade_eixos,
    combustivel,
    tara_kg,
    capacidade_carga_kg,
    volume_m3,
    status,
    adicionado_em,
    motorista_id,
    manutencao_pendente,
    seguro_validade,
    cliente_id
) VALUES
    (1, 'BRA2E19', '63124578901', '12345678', 2021, 2022, 'CARRETA', NULL, 6, 'Diesel', 9000, 30000, 92, 'DISPONIVEL', '2026-02-15 08:00:00', 1, FALSE, '2027-09-30', 1),
    (2, 'CPN4H27', '74235689012', '22345678', 2020, 2021, 'TRUCK', NULL, 3, 'Diesel', 6500, 14000, 48, 'DISPONIVEL', '2026-02-15 08:10:00', 2, FALSE, '2027-10-12', 2),
    (3, 'DRT5J38', '85346790123', '32345678', 2019, 2020, 'TOCO', NULL, 2, 'Diesel', 4200, 8000, 32, 'DISPONIVEL', '2026-02-15 08:20:00', 3, FALSE, '2027-11-05', 3),
    (4, 'FGM6K49', '96457801234', '42345678', 2022, 2023, 'CARRETA', NULL, 6, 'Diesel', 8800, 28000, 88, 'DISPONIVEL', '2026-02-15 08:30:00', 4, FALSE, '2027-12-18', 4),
    (5, 'HQL7L51', '17568912345', '52345678', 2021, 2021, 'VUC', NULL, 2, 'Diesel', 2300, 3500, 18, 'DISPONIVEL', '2026-02-15 08:40:00', 5, FALSE, '2027-08-25', 5),
    (6, 'JVS8M62', '28679023456', '62345678', 2020, 2021, 'BITRUCK', NULL, 4, 'Diesel', 7200, 18000, 60, 'DISPONIVEL', '2026-02-15 08:50:00', 6, FALSE, '2027-11-30', 6),
    (7, 'KXT9N73', '39780134567', '72345678', 2022, 2022, 'CARRETA', NULL, 6, 'Diesel', 9500, 32000, 96, 'DISPONIVEL', '2026-02-15 09:00:00', 7, FALSE, '2027-10-21', 7),
    (8, 'LPA1P84', '40891245678', '82345678', 2021, 2022, 'TRUCK', NULL, 3, 'Diesel', 6700, 15000, 50, 'DISPONIVEL', '2026-02-15 09:10:00', 8, FALSE, '2027-09-17', 8),
    (9, 'MRC2R95', '51902356789', '92345678', 2019, 2020, 'TOCO', NULL, 2, 'Diesel', 4300, 9000, 34, 'DISPONIVEL', '2026-02-15 09:20:00', 9, FALSE, '2027-12-09', 9),
    (10, 'NDU3S06', '62013467890', '10345678', 2023, 2024, 'CARRETA', NULL, 6, 'Diesel', 8600, 26000, 84, 'DISPONIVEL', '2026-02-15 09:30:00', 10, FALSE, '2027-11-14', 10);

INSERT INTO frete (
    id,
    numero_frete,
    remetente_id,
    destinatario_id,
    endereco_origem_id,
    endereco_destino_id,
    motorista_id,
    veiculo_id,
    chave_nfe,
    origem_ibge,
    destino_ibge,
    natureza_carga,
    peso_bruto,
    volumes,
    distancia_km,
    valor_frete_bruto,
    valor_pedagio,
    aliquota_icms,
    valor_icms,
    valor_total,
    status,
    data_emissao,
    previsao_entrega,
    data_saida,
    data_entrega,
    motivo_falha
) VALUES
    (1, 'FRT-2026-0001', 1, 7, 1, 14, 1, 1, '35260511222333000181550010000000011000000011', '3550308', '2910800', 'Eletrodomesticos', 12500.000, 22, 1960.50, 8500.00, 320.00, 7.00, 595.00, 9415.00, 'EMITIDO', '2026-05-01 08:30:00', '2026-05-06', NULL, NULL, NULL),
    (2, 'FRT-2026-0002', 2, 8, 3, 16, 2, 2, '35260522333444000181550010000000021000000022', '3509502', '2607901', 'Alimentos secos', 6800.000, 140, 2120.00, 6200.00, 280.00, 7.00, 434.00, 6914.00, 'EMITIDO', '2026-05-02 09:15:00', '2026-05-08', NULL, NULL, NULL),
    (3, 'FRT-2026-0003', 3, 9, 5, 18, 3, 3, '33260533444555000181550010000000031000000033', '3304557', '2307650', 'Higiene pessoal', 4300.000, 96, 2850.75, 7100.00, 340.00, 7.00, 497.00, 7937.00, 'EMITIDO', '2026-05-03 10:00:00', '2026-05-09', NULL, NULL, NULL),
    (4, 'FRT-2026-0004', 4, 10, 7, 20, 4, 4, '31260544555666000181550010000000041000000044', '3106200', '5201405', 'Medicamentos hospitalares', 15800.000, 34, 910.40, 9800.00, 410.00, 7.00, 686.00, 10896.00, 'EMITIDO', '2026-05-04 11:20:00', '2026-05-07', NULL, NULL, NULL),
    (5, 'FRT-2026-0005', 5, 6, 9, 12, 5, 5, '41260555666777000181550010000000051000000055', '4106902', '4304606', 'Tintas e ferramentas', 2200.000, 58, 710.30, 5400.00, 190.00, 12.00, 648.00, 6238.00, 'EMITIDO', '2026-05-05 08:50:00', '2026-05-09', NULL, NULL, NULL),
    (6, 'FRT-2026-0006', 6, 5, 11, 10, 6, 6, '43260566777888000181550010000000061000000066', '4314902', '4125506', 'Bebidas nao alcoolicas', 9600.000, 120, 708.90, 5600.00, 210.00, 12.00, 672.00, 6482.00, 'EMITIDO', '2026-05-06 09:40:00', '2026-05-10', NULL, NULL, NULL),
    (7, 'FRT-2026-0007', 7, 1, 13, 2, 7, 7, '29260577888999000181550010000000071000000077', '2927408', '3518800', 'Graos ensacados', 14100.000, 26, 1965.60, 8700.00, 330.00, 12.00, 1044.00, 10074.00, 'EMITIDO', '2026-05-07 13:10:00', '2026-05-13', NULL, NULL, NULL),
    (8, 'FRT-2026-0008', 8, 2, 15, 4, 8, 8, '26260588999000000198550010000000081000000088', '2611606', '3525904', 'Insumos hospitalares', 7300.000, 88, 2135.20, 6400.00, 260.00, 12.00, 768.00, 7428.00, 'EMITIDO', '2026-05-08 14:00:00', '2026-05-14', NULL, NULL, NULL),
    (9, 'FRT-2026-0009', 9, 3, 17, 6, 9, 9, '23260599000111000165550010000000091000000099', '2304400', '3301702', 'Polpas e frutas congeladas', 4100.000, 72, 2862.10, 7300.00, 350.00, 12.00, 876.00, 8526.00, 'EMITIDO', '2026-05-09 07:55:00', '2026-05-15', NULL, NULL, NULL),
    (10, 'FRT-2026-0010', 10, 4, 19, 8, 10, 10, '52260512131415000183550010000000101000000101', '5208707', '3118601', 'Pecas e equipamentos industriais', 11800.000, 40, 912.70, 9100.00, 390.00, 12.00, 1092.00, 10582.00, 'EMITIDO', '2026-05-10 15:20:00', '2026-05-16', NULL, NULL, NULL);

INSERT INTO ocorrencia_frete (
    id,
    frete_id,
    tipo,
    data_hora,
    municipio,
    uf,
    latitude,
    longitude,
    descricao,
    recebedor_nome,
    recebedor_documento,
    foto_evidencia_url
) VALUES
    (1, 1, 'OUTROS', '2026-05-01 10:00:00', 'Sao Paulo', 'SP', -23.59557400, -46.68954800, 'Carga separada e janela de coleta confirmada com o expedidor.', NULL, NULL, NULL),
    (2, 2, 'OUTROS', '2026-05-02 11:00:00', 'Campinas', 'SP', -22.90556000, -47.06083000, 'Documentacao fiscal conferida e liberacao de patio registrada.', NULL, NULL, NULL),
    (3, 3, 'OUTROS', '2026-05-03 12:10:00', 'Rio de Janeiro', 'RJ', -22.90350000, -43.17720000, 'Coleta reagendada para encaixe na doca do centro de distribuicao.', NULL, NULL, NULL),
    (4, 4, 'OUTROS', '2026-05-04 13:00:00', 'Belo Horizonte', 'MG', -19.91910000, -43.93860000, 'Equipe de expedicao confirmou segregacao da carga hospitalar.', NULL, NULL, NULL),
    (5, 5, 'OUTROS', '2026-05-05 10:15:00', 'Curitiba', 'PR', -25.43190000, -49.27310000, 'Paletes conferidos e lacres separados para embarque.', NULL, NULL, NULL),
    (6, 6, 'OUTROS', '2026-05-06 11:30:00', 'Porto Alegre', 'RS', -30.01980000, -51.21910000, 'Carga aguardando encaixe final de romaneio no patio.', NULL, NULL, NULL),
    (7, 7, 'OUTROS', '2026-05-07 14:20:00', 'Salvador', 'BA', -12.97180000, -38.50110000, 'Expedidor confirmou pesagem e liberou emissao do manifesto.', NULL, NULL, NULL),
    (8, 8, 'OUTROS', '2026-05-08 15:10:00', 'Recife', 'PE', -8.06310000, -34.87110000, 'Separacao final concluida e conferencia de volumes registrada.', NULL, NULL, NULL),
    (9, 9, 'OUTROS', '2026-05-09 09:05:00', 'Fortaleza', 'CE', -3.73190000, -38.52670000, 'Camara fria validada e carga pronta para coleta.', NULL, NULL, NULL),
    (10, 10, 'OUTROS', '2026-05-10 16:10:00', 'Goiania', 'GO', -16.67330000, -49.25640000, 'Checklist operacional finalizado e pedido liberado para programacao.', NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('cliente', 'id'), COALESCE((SELECT MAX(id) FROM cliente), 1), TRUE);
SELECT setval(pg_get_serial_sequence('endereco', 'id'), COALESCE((SELECT MAX(id) FROM endereco), 1), TRUE);
SELECT setval(pg_get_serial_sequence('usuario', 'id'), COALESCE((SELECT MAX(id) FROM usuario), 1), TRUE);
SELECT setval(pg_get_serial_sequence('motorista', 'id'), COALESCE((SELECT MAX(id) FROM motorista), 1), TRUE);
SELECT setval(pg_get_serial_sequence('veiculo', 'id'), COALESCE((SELECT MAX(id) FROM veiculo), 1), TRUE);
SELECT setval(pg_get_serial_sequence('frete', 'id'), COALESCE((SELECT MAX(id) FROM frete), 1), TRUE);
SELECT setval(pg_get_serial_sequence('ocorrencia_frete', 'id'), COALESCE((SELECT MAX(id) FROM ocorrencia_frete), 1), TRUE);

COMMIT;
