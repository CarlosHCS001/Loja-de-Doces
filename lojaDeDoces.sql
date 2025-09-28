-- ===============================================
-- Banco de Dados: Loja de Doces
-- Autor: carlos henrique

-- ===============================================

-- =========================
-- Criação das Tabelas
-- =========================

-- Tabela de categorias de doces
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

-- Tabela de produtos
CREATE TABLE produtos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    preco REAL NOT NULL,
    estoque INTEGER NOT NULL,
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabela de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT UNIQUE,
    telefone TEXT
);

-- Tabela de vendas
CREATE TABLE vendas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabela de itens da venda
CREATE TABLE itens_venda (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    venda_id INTEGER,
    produto_id INTEGER,
    quantidade INTEGER NOT NULL,
    preco_unitario REAL NOT NULL,
    FOREIGN KEY (venda_id) REFERENCES vendas(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- =========================
-- Inserção de dados de exemplo
-- =========================

-- Categorias
INSERT INTO categorias (nome) VALUES ('Chocolates');
INSERT INTO categorias (nome) VALUES ('Balas');
INSERT INTO categorias (nome) VALUES ('Bolos');
INSERT INTO categorias (nome) VALUES ('Doces Caseiros');

-- Produtos
INSERT INTO produtos (nome, preco, estoque, categoria_id) VALUES ('Chocolate ao Leite', 5.50, 50, 1);
INSERT INTO produtos (nome, preco, estoque, categoria_id) VALUES ('Bala de Goma', 0.50, 200, 2);
INSERT INTO produtos (nome, preco, estoque, categoria_id) VALUES ('Bolo de Cenoura', 15.00, 20, 3);
INSERT INTO produtos (nome, preco, estoque, categoria_id) VALUES ('Brigadeiro Caseiro', 2.50, 100, 4);

-- Clientes
INSERT INTO clientes (nome, email, telefone) VALUES ('Maria Silva', 'maria@email.com', '11999999999');
INSERT INTO clientes (nome, email, telefone) VALUES ('João Souza', 'joao@email.com', '11988888888');

-- Vendas
INSERT INTO vendas (cliente_id) VALUES (1);
INSERT INTO vendas (cliente_id) VALUES (2);

-- Itens da venda
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES (1, 1, 2, 5.50);
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES (1, 4, 5, 2.50);
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES (2, 2, 10, 0.50);
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES (2, 3, 1, 15.00);

-- =========================
-- Queries Criativas
-- =========================

-- 1. Total de vendas por cliente
SELECT c.nome, SUM(i.quantidade * i.preco_unitario) AS total_gasto
FROM clientes c
JOIN vendas v ON c.id = v.cliente_id
JOIN itens_venda i ON v.id = i.venda_id
GROUP BY c.id;

-- 2. Produtos mais vendidos
SELECT p.nome, SUM(i.quantidade) AS total_vendido
FROM produtos p
JOIN itens_venda i ON p.id = i.produto_id
GROUP BY p.id
ORDER BY total_vendido DESC;

-- 3. Vendas por categoria
SELECT cat.nome AS categoria, SUM(i.quantidade * i.preco_unitario) AS total_vendas
FROM categorias cat
JOIN produtos p ON cat.id = p.categoria_id
JOIN itens_venda i ON p.id = i.produto_id
GROUP BY cat.id;

-- 4. Estoque atual dos produtos
SELECT nome, estoque FROM produtos;

-- 5. Relatório detalhado de uma venda específica
SELECT v.id AS venda_id, c.nome AS cliente, p.nome AS produto, i.quantidade, i.preco_unitario, (i.quantidade*i.preco_unitario) AS total_item
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_venda i ON v.id = i.venda_id
JOIN produtos p ON i.produto_id = p.id
WHERE v.id = 1;
