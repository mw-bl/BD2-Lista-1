-- QUESTÕES SOBRE FUNÇÕES

-- QUESTÃO 1
-- Crie uma função chamada CalcularIdade que receba a data de nascimento 
-- de um cliente e retorne à idade atual.

CREATE OR REPLACE FUNCTION CalcularIdade(DataNascimento DATE)
RETURNS INT AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM age(current_date, DataNascimento));
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 2
-- Crie uma função chamada VerificarEstoque que receba o ProdutoID e retorne 
-- a quantidade em estoque daquele produto.

CREATE OR REPLACE FUNCTION VerificarEstoque(ProdutoID INT)
RETURNS INT AS $$
DECLARE
    QuantidadeEstoque INT;
BEGIN
    SELECT Estoque INTO QuantidadeEstoque
    FROM Produtos
    WHERE ProdutoID = VerificarEstoque.ProdutoID;

    RETURN QuantidadeEstoque;
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 3
-- Crie uma função chamada CalcularDesconto que receba o ProdutoID e um percentual de desconto, 
-- e retorne o preço final do produto após aplicar o desconto.

CREATE OR REPLACE FUNCTION CalcularDesconto(ProdutoID INT, PercentualDesconto DECIMAL)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    PrecoOriginal DECIMAL(10, 2);
    PrecoFinal DECIMAL(10, 2);
BEGIN
    SELECT Preco INTO PrecoOriginal
    FROM Produtos
    WHERE ProdutoID = CalcularDesconto.ProdutoID;

    PrecoFinal := PrecoOriginal - (PrecoOriginal * PercentualDesconto / 100);

    RETURN PrecoFinal;
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 4
-- Crie uma função chamada ObterNomeCliente que receba o ClienteID e retorne o nome completo do cliente.

CREATE OR REPLACE FUNCTION ObterNomeCliente(ClienteID INT)
RETURNS VARCHAR(100) AS $$
DECLARE
    NomeCliente VARCHAR(100);
BEGIN
    SELECT Nome INTO NomeCliente
    FROM Clientes
    WHERE ClienteID = ObterNomeCliente.ClienteID;

    RETURN NomeCliente;
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 5
-- Crie uma função chamada CalcularFrete que receba o valor total de um pedido e a cidade
-- do cliente. Se a cidade for "São Paulo", o frete deve ser 5% do valor do pedido; para outras
-- cidades, deve ser 10%. Use IF ELSE para definir a taxa de frete.

CREATE OR REPLACE FUNCTION CalcularFrete(ValorTotal DECIMAL(10, 2), CidadeCliente VARCHAR(50))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    Frete DECIMAL(10, 2);
BEGIN
    IF CidadeCliente = 'São Paulo' THEN
        Frete := ValorTotal * 0.05;
    ELSE
        Frete := ValorTotal * 0.10;
    END IF;

    RETURN Frete;
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 6
-- Crie uma função chamada CalcularPontos que receba um ClienteID e percorra todos os
-- pedidos do cliente. Para cada pedido, se o valor total for maior que R$ 100, adicione 10
-- pontos; se for menor ou igual, adicione 5 pontos. Retorne o total de pontos acumulados
-- pelo cliente. Use FOR e IF ELSE.

CREATE OR REPLACE FUNCTION CalcularPontos(ClienteID INT)
RETURNS INT AS $$
DECLARE
    Pedido RECORD;
    TotalPontos INT := 0;
BEGIN
    FOR Pedido IN
        SELECT ValorTotal FROM Pedidos
        WHERE ClienteID = CalcularPontos.ClienteID
    LOOP
        IF Pedido.ValorTotal > 100 THEN
            TotalPontos := TotalPontos + 10;
        ELSE
            TotalPontos := TotalPontos + 5;
        END IF;
    END LOOP;

    RETURN TotalPontos;
END;
$$ LANGUAGE plpgsql;
