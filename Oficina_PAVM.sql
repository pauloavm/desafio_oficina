-- SCRIPT DE BANCO DE DADOS PARA OFICINA MECÂNICA

-- -----------------------------------------------------
-- Tabela `Clientes`
-- Armazena os dados dos proprietários dos veículos.
-- -----------------------------------------------------
CREATE TABLE Clientes (
  cliente_id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(100)
);

-- -----------------------------------------------------
-- Tabela `Veiculos`
-- Armazena os dados dos veículos, com uma referência ao seu proprietário (cliente).
-- -----------------------------------------------------
CREATE TABLE Veiculos (
  veiculo_id INT PRIMARY KEY AUTO_INCREMENT,
  placa VARCHAR(10) NOT NULL UNIQUE,
  marca VARCHAR(50),
  modelo VARCHAR(50),
  ano INT,
  cliente_id INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- -----------------------------------------------------
-- Tabela `Equipes`
-- Armazena as equipes de mecânicos.
-- -----------------------------------------------------
CREATE TABLE Equipes (
  equipe_id INT PRIMARY KEY AUTO_INCREMENT,
  nome_equipe VARCHAR(100) NOT NULL
);

-- -----------------------------------------------------
-- Tabela `Mecanicos`
-- Armazena os dados dos mecânicos e a qual equipe eles pertencem.
-- -----------------------------------------------------
CREATE TABLE Mecanicos (
  mecanico_id INT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(255) NOT NULL,
  endereco TEXT,
  especialidade VARCHAR(150),
  equipe_id INT NOT NULL,
  FOREIGN KEY (equipe_id) REFERENCES Equipes(equipe_id)
);

-- -----------------------------------------------------
-- Tabela `Servicos`
-- Tabela de referência para todos os serviços que a oficina oferece,
-- incluindo o valor da mão-de-obra.
-- -----------------------------------------------------
CREATE TABLE Servicos (
  servico_id INT PRIMARY KEY AUTO_INCREMENT,
  nome_servico VARCHAR(255) NOT NULL,
  descricao TEXT,
  valor_mao_obra DECIMAL(10, 2) NOT NULL
);

-- -----------------------------------------------------
-- Tabela `Pecas`
-- Catálogo de peças disponíveis, com seus respectivos valores.
-- -----------------------------------------------------
CREATE TABLE Pecas (
  peca_id INT PRIMARY KEY AUTO_INCREMENT,
  nome_peca VARCHAR(255) NOT NULL,
  descricao TEXT,
  valor_unitario DECIMAL(10, 2) NOT NULL
);

-- -----------------------------------------------------
-- Tabela `Ordens_Servico`
-- Tabela central que armazena os dados de cada Ordem de Serviço.
-- -----------------------------------------------------
CREATE TABLE Ordens_Servico (
  os_id INT PRIMARY KEY AUTO_INCREMENT,
  numero_os VARCHAR(50) NOT NULL UNIQUE,
  data_emissao DATE NOT NULL,
  data_prevista_conclusao DATE,
  data_conclusao_real DATE,
  valor_total DECIMAL(10, 2),
  status ENUM('Aguardando Avaliação', 'Aguardando Aprovação', 'Aprovada', 'Em Execução', 'Concluída', 'Cancelada') NOT NULL,
  veiculo_id INT NOT NULL,
  equipe_id INT NOT NULL,
  FOREIGN KEY (veiculo_id) REFERENCES Veiculos(veiculo_id),
  FOREIGN KEY (equipe_id) REFERENCES Equipes(equipe_id)
);

-- -----------------------------------------------------
-- Tabela de Ligação `Ordens_Servico_Servicos`
-- Conecta as Ordens de Serviço aos Serviços (relação N:M).
-- -----------------------------------------------------
CREATE TABLE Ordens_Servico_Servicos (
  os_id INT NOT NULL,
  servico_id INT NOT NULL,
  PRIMARY KEY (os_id, servico_id),
  FOREIGN KEY (os_id) REFERENCES Ordens_Servico(os_id),
  FOREIGN KEY (servico_id) REFERENCES Servicos(servico_id)
);

-- -----------------------------------------------------
-- Tabela de Ligação `Ordens_Servico_Pecas`
-- Conecta as Ordens de Serviço às Peças utilizadas (relação N:M).
-- -----------------------------------------------------
CREATE TABLE Ordens_Servico_Pecas (
  os_id INT NOT NULL,
  peca_id INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 1,
  PRIMARY KEY (os_id, peca_id),
  FOREIGN KEY (os_id) REFERENCES Ordens_Servico(os_id),
  FOREIGN KEY (peca_id) REFERENCES Pecas(peca_id)
);