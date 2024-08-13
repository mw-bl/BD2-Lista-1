CREATE table Clientes (
 	ClienteID SERIAL PRIMARY KEY,
 	Nome VARCHAR(100) not NULL,
 	Email VARCHAR(100) not NULL, 
 	DataNascimento DATE NOT NULL,
 	Cidade VARCHAR(50) not NULL
);

CREATE TABLE Produtos (
	ProdutoID SERIAL PRIMARY key,
 	NomeProduto VARCHAR(100) not NULL,
  	Categoria VARCHAR(50) not NULL,
  	Preco DECIMAL(10,2) not NULL,
  	Estoque INT not NULL
);

CREATE TABLE Pedidos (
    PedidoID SERIAL PRIMARY KEY,
    ClienteID INT NOT NULL,
    DataPedido DATE NOT NULL,
    ValorTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);


CREATE TABLE ItensPedido (
    ItemID SERIAL PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);