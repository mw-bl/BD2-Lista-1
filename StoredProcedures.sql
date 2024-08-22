-- QUESTÃO 1
-- Crie um procedimento chamado AtualizarEstoqueEmMassa que receba uma lista de
-- ProdutoID e uma quantidade a ser adicionada ao estoque de cada produto. O
-- procedimento deve usar um loop FOR para percorrer cada ProdutoID e atualizar o estoque.

CREATE OR REPLACE PROCEDURE AtualizarEstoqueEmMassa(ProdutoIDs INT[], QuantidadeAdicionar INT)
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..array_length(ProdutoIDs, 1) LOOP
        UPDATE Produtos
        SET Estoque = Estoque + QuantidadeAdicionar
        WHERE ProdutoID = ProdutoIDs[i];
    END LOOP;
END;
$$;


-- QUESTÃO 2
-- Crie um procedimento chamado InserirCliente que insira um novo cliente na tabela Clientes.

CREATE OR REPLACE PROCEDURE InserirCliente(
    NomeCliente VARCHAR(100),
    EmailCliente VARCHAR(100),
    DataNascimentoCliente DATE,
    CidadeCliente VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Clientes (Nome, Email, DataNascimento, Cidade)
    VALUES (NomeCliente, EmailCliente, DataNascimentoCliente, CidadeCliente);
END;
$$;


-- QUESTÃO 3
-- Crie um procedimento chamado RealizarPedido que insira um novo pedido na tabela
-- Pedidos e os itens correspondentes na tabela ItensPedido.

CREATE OR REPLACE PROCEDURE RealizarPedido(
    ClienteID INT,
    ProdutoIDs INT[],
    Quantidades INT[],
    ValorTotal DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    NovoPedidoID INT;
    i INT;
    PrecoUnitario DECIMAL(10, 2);
BEGIN
    INSERT INTO Pedidos (ClienteID, DataPedido, ValorTotal)
    VALUES (ClienteID, current_date, ValorTotal)
    RETURNING PedidoID INTO NovoPedidoID;

    FOR i IN 1..array_length(ProdutoIDs, 1) LOOP
        SELECT Preco INTO PrecoUnitario
        FROM Produtos
        WHERE ProdutoID = ProdutoIDs[i];

        INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario)
        VALUES (NovoPedidoID, ProdutoIDs[i], Quantidades[i], PrecoUnitario);
    END LOOP;
END;
$$;


-- QUESTÃO 4
-- Crie um procedimento chamado ExcluirCliente que exclua um cliente da tabela Clientes e
-- todos os pedidos associados a esse cliente.

CREATE OR REPLACE PROCEDURE ExcluirCliente(ClienteID INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM ItensPedido
    WHERE PedidoID IN (SELECT PedidoID FROM Pedidos WHERE ClienteID = ExcluirCliente.ClienteID);

    DELETE FROM Pedidos
    WHERE ClienteID = ExcluirCliente.ClienteID;

    DELETE FROM Clientes
    WHERE ClienteID = ExcluirCliente.ClienteID;
END;
$$;


-- QUESTÃO 5
-- Crie um procedimento chamado AtualizarPrecoProduto que receba o ProdutoID e o novo
-- preço, e atualize o preço do produto na tabela Produtos

CREATE OR REPLACE PROCEDURE AtualizarPrecoProduto(
    ProdutoID INT,
    NovoPreco DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Produtos
    SET Preco = NovoPreco
    WHERE ProdutoID = AtualizarPrecoProduto.ProdutoID;
END;
$$;


-- QUESTÃO 6
-- Crie um procedimento chamado InserirClienteComVerificacao que receba os dados de
-- um cliente (Nome, Email, DataNascimento, Cidade). Antes de inserir o cliente, verifique se
-- o email já existe na tabela Clientes. Se existir, não insira e retorne uma mensagem de erro.
-- Use DECLARE para declarar variáveis e IF ELSE para a verificação.

CREATE OR REPLACE PROCEDURE InserirClienteComVerificacao(
    NomeCliente VARCHAR(100),
    EmailCliente VARCHAR(100),
    DataNascimentoCliente DATE,
    CidadeCliente VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    EmailExistente INT;
BEGIN
    SELECT COUNT(*) INTO EmailExistente
    FROM Clientes
    WHERE Email = EmailCliente;

    IF EmailExistente > 0 THEN
        RAISE EXCEPTION 'O email % já está cadastrado.', EmailCliente;
    ELSE
        INSERT INTO Clientes (Nome, Email, DataNascimento, Cidade)
        VALUES (NomeCliente, EmailCliente, DataNascimentoCliente, CidadeCliente);
    END IF;
END;
$$;
