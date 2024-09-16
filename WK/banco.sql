CREATE DATABASE

IF NOT EXISTS WK_Teste;
	USE WK_Teste;

CREATE TABLE clientes 
(
    codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    PRIMARY KEY (codigo)
);

CREATE TABLE produtos 
(
    codigo INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL DEFAULT '0.00',
    PRIMARY KEY (codigo)
);

CREATE TABLE pedidos_dados_gerais 
(
    num_pedido INT NOT NULL AUTO_INCREMENT,
    data_emissao DATE NULL DEFAULT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10,2) NULL DEFAULT '0.00',
    PRIMARY KEY (num_pedido),
    INDEX (codigo_cliente),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

CREATE TABLE pedidos_produtos 
(
    autoincrem INT NOT NULL AUTO_INCREMENT,
    num_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    vlr_unitario DECIMAL(10,2) NULL DEFAULT '0.00',
    vlr_total DECIMAL(10,2) NULL DEFAULT '0.00',
    PRIMARY KEY (autoincrem),
    INDEX (num_pedido),
    INDEX (codigo_produto),
    CONSTRAINT fk_pedidos_produtos_pedido FOREIGN KEY (num_pedido) REFERENCES pedidos_dados_gerais(num_pedido),
    CONSTRAINT fk_pedidos_produtos_produto FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Dados para teste

INSERT INTO clientes (nome, cidade, uf)
VALUES
    ('Ana Clara Silva', 'João Pessoa', 'PB'),
    ('Lucas Oliveira', 'Campina Grande', 'PB'),
    ('Beatriz Costa', 'Recife', 'PE'),
    ('Pedro Henrique', 'Olinda', 'PE'),
    ('Juliana Santos', 'Cajazeiras', 'PB'),
    ('Felipe Almeida', 'Sousa', 'PB'),
    ('Gabriela Martins', 'Recife', 'PE'),
    ('Rodrigo Lima', 'Jaboatão dos Guararapes', 'PE'),
    ('Carla Souza', 'Natal', 'RN'),
    ('Ricardo Ferreira', 'Mossoró', 'RN'),
    ('Tatiane Rocha', 'Currais Novos', 'RN'),
    ('Fernando Almeida', 'Campina Grande', 'PB'),
    ('Larissa Pereira', 'Patos', 'PB'),
    ('João Paulo', 'Sousa', 'PB'),
    ('Mariana Lima', 'Natal', 'RN'),
    ('Roberto Silva', 'São Paulo', 'SP'),
    ('Ana Beatriz', 'São Paulo', 'SP'),
    ('Matheus Costa', 'Patos', 'PB'),
    ('Carlos Eduardo', 'Aparecida', 'PB'),
    ('Fernanda Lima', 'São Paulo', 'SP');


INSERT INTO produtos (descricao, preco_venda)
VALUES
    ('Arroz Integral', '5.20'),
    ('Suco de Laranja', '3.50'),
    ('Macarrão Integral', '3.00'),
    ('Maionese Caseira', '4.20'),
    ('Molho Barbecue', '3.80'),
    ('Queijo Prato', '7.00'),
    ('Presunto', '5.50'),
    ('Pão de Forma', '2.20'),
    ('Água Mineral', '1.50'),
    ('Suco de Uva', '4.00'),
    ('Refrigerante de Laranja', '6.00'),
    ('Óleo de Canola', '5.20'),
    ('Vinagre', '2.10'),
    ('Farinha de Mandioca', '3.00'),
    ('Feijão Preto', '7.20'),
    ('Feijão Branco', '6.80'),
    ('Cerveja Skol', '3.50'),
    ('Cerveja Brahma', '3.70'),
    ('Molho Pimenta', '2.50'),
    ('Queijo Cheddar', '8.00'),
    ('Café em Pó', '4.50'),
    ('Leite Condensado', '3.70'),
    ('Farinha de Milho', '2.60');

