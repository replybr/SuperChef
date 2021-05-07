--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table atendentes(
   codigo COUNTER  primary key,
   nome Varchar(20),
   comissao Decimal(10,2)
   );
---------------------------------------------------------
--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table bancos(
   codigo COUNTER primary key,
   nome Varchar(20),
   banco Varchar(10),
   agencia Varchar(10),
   conta_c Varchar(10),
   limite Decimal(12,2),
   titular Varchar(20),
   gerente Varchar(20),
   telefone Varchar(10)
   );
---------------------------------------------------------
--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table clientes(
   codigo Counter primary key,
   nome Varchar(40),
   fixo Varchar(10),
   celular Varchar(10),
   endereco Varchar(40),
   numero Varchar(6),
   complem Varchar(20),
   bairro Varchar(20),
   cidade Varchar(20),
   uf Varchar(2),
   cep Varchar(8),
   email Varchar(50),
   aniv_dia INTEGER,
   aniv_mes INTEGER
   );
---------------------------------------------------------
Create Table empresa(
   nome Varchar(40),
   fixo_1 Varchar(10),
   fixo_2 Varchar(10),
   endereco Varchar(40),
   numero Varchar(6),
   complem Varchar(20),
   bairro Varchar(20),
   cidade Varchar(20),
   uf Varchar(2),
   cep Varchar(8),
   email Varchar(50),
   site Varchar(50)
   );
---------------------------------------------------------
Create Table grupo_apoio(
   codigo COUNTER primary key,
   tabela integer not null,
   nome Varchar(20)
   );

--Create Table categoria_produtos(
--   codigo INTEGER,
--   nome Varchar(20)
--   );
--Create Table subcategoria_produtos(
--   codigo INTEGER,
--   nome Varchar(20)
--   );
--Create Table unidade_medida(
--   codigo INTEGER,
--   nome Varchar(10)
--   );
--Create Table grupo_fornecedores(
--   codigo INTEGER,
--   nome Varchar(20)
--   );
---------------------------------------------------------
--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table fornecedores(
   codigo COUNTER primary key,
   nome Varchar(40),
   fixo Varchar(10),
   celular Varchar(10),
   endereco Varchar(40),
   numero Varchar(6),
   complem Varchar(20),
   bairro Varchar(20),
   cidade Varchar(20),
   uf Varchar(2),
   cep Varchar(8),
   email Varchar(50),
   grupo INTEGER,
   CONSTRAINT FKfornecedores_grupo_apoio FOREIGN KEY (grupo) REFERENCES grupo_apoio
   );
--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table motoboys(
   codigo COUNTER Primary key,
   nome Varchar(20),
   comissao Decimal(10,2),
   diaria Decimal(10,2),
   fixo Varchar(10),
   celular Varchar(10),
   endereco Varchar(40),
   numero Varchar(10),
   complem Varchar(20),
   bairro Varchar(20),
   cidade Varchar(20),
   uf Varchar(2),
   cep Varchar(8),
   email Varchar(40)
   );
   
--Definido atendentes c�digo auto-incremento e primary key
--Executado
Create Table operadores(
   codigo COUNTER Primary key,
   nome Varchar(10),
   senha Varchar(10),
   acesso varchar(100) --Eliminado a tabela acesso, este campo substitui a tabela.
   );   
---------------------------------------------------------
Create Table bordas(
   nome Varchar(15),
   preco Decimal(10,2)
   );

Create Table caixa(
   id Varchar(10),
   data DateTime,
   historico Varchar(30),
   entrada Decimal(12,2),
   saida Decimal(12,2)
   );



Create Table detalhamento_compras(
   id_cliente INTEGER,
   data DateTime,
   hora Varchar(8),
   id_prod Varchar(10),
   qtd INTEGER,
   unitario Decimal(10,2),
   subtotal Decimal(12,2)
   );

Create Table ultimas_compras(
   id_cliente INTEGER,
   data DateTime,
   hora Varchar(8),
   onde INTEGER,
   valor Decimal(12,2)
   );



Create Table comissao_mesa(
   id INTEGER,
   data DateTime,
   hora Varchar(8),
   valor Decimal(12,2)
   );

Create Table comissao(
   id INTEGER,
   data DateTime,
   hora Varchar(8),
   valor Decimal(12,2)
   );

Create Table config(
   tipo INTEGER
   );

--Rever a tabela Conta, os recurso Sum do SQL pode prover esta informa��o automaticamente.
Create Table conta(
   c_clientes INTEGER,
   c_fornec INTEGER,
   c_gfornec INTEGER,
   c_mprima INTEGER,
   c_catprod INTEGER,
   c_scatprod INTEGER,
   c_mesas INTEGER,
   c_frecebe INTEGER,
   c_fpaga INTEGER,
   c_umedida INTEGER,
   c_bancos INTEGER,
   c_impostos INTEGER,
   c_atende INTEGER,
   c_motent INTEGER,
   c_operador INTEGER
   );

Create Table contas_pagar(
   id Varchar(10),
   data DateTime,
   valor Decimal(12,2),
   forma INTEGER,
   fornec INTEGER,
   numero Varchar(15),
   obs Varchar(30),
   baixa BIT
   );

Create Table contas_receber(
   id Varchar(10),
   data DateTime,
   valor Decimal(12,2),
   forma INTEGER,
   cliente INTEGER,
   numero Varchar(15),
   obs Varchar(30),
   baixa BIT
   );

Create Table entrega(
   cliente Varchar(30),
   endereco Varchar(30),
   hora Varchar(8),
   origem Varchar(10),
   telefone Varchar(10),
   cod_moto INTEGER,
   motoboy Varchar(15),
   situacao Varchar(15),
   vlr_taxa Decimal(10,2)
   );

Create Table forma_pagamentos(
   codigo INTEGER,
   nome Varchar(20),
   banco INTEGER,
   dias_paga INTEGER
   );

Create Table formas_recebimento(
   codigo INTEGER,
   nome Varchar(20),
   banco INTEGER,
   dias_receb INTEGER
   );



Create Table impostos(
   codigo INTEGER,
   nome Varchar(20),
   aliquota Decimal(10,2)
   );

Create Table acesso(
   operador INTEGER,
   acesso_001 BIT,
   acesso_002 BIT,
   acesso_003 BIT,
   acesso_004 BIT,
   acesso_005 BIT,
   acesso_006 BIT,
   acesso_007 BIT,
   acesso_008 BIT,
   acesso_009 BIT,
   acesso_010 BIT,
   acesso_011 BIT,
   acesso_012 BIT,
   acesso_013 BIT,
   acesso_014 BIT,
   acesso_015 BIT,
   acesso_016 BIT,
   acesso_017 BIT,
   acesso_018 BIT,
   acesso_019 BIT,
   acesso_020 BIT,
   acesso_021 BIT,
   acesso_022 BIT,
   acesso_023 BIT,
   acesso_024 BIT,
   acesso_025 BIT,
   acesso_026 BIT,
   acesso_027 BIT,
   acesso_028 BIT,
   acesso_029 BIT,
   acesso_030 BIT,
   acesso_031 BIT,
   acesso_032 BIT,
   acesso_033 BIT,
   acesso_034 BIT,
   acesso_035 BIT,
   acesso_036 BIT,
   acesso_037 BIT,
   acesso_038 BIT,
   acesso_039 BIT,
   acesso_040 BIT,
   acesso_041 BIT,
   acesso_042 BIT,
   acesso_043 BIT,
   acesso_044 BIT,
   acesso_045 BIT,
   acesso_046 BIT,
   acesso_047 BIT,
   acesso_048 BIT,
   acesso_049 BIT,
   acesso_050 BIT,
   acesso_051 BIT,
   acesso_052 BIT,
   acesso_053 BIT,
   acesso_054 BIT,
   acesso_055 BIT,
   acesso_056 BIT,
   acesso_057 BIT,
   acesso_058 BIT,
   acesso_059 BIT,
   acesso_060 BIT,
   acesso_061 BIT,
   acesso_062 BIT,
   acesso_063 BIT,
   acesso_064 BIT,
   acesso_065 BIT,
   acesso_066 BIT,
   acesso_067 BIT,
   acesso_068 BIT,
   acesso_069 BIT,
   acesso_070 BIT,
   acesso_071 BIT,
   acesso_072 BIT,
   acesso_073 BIT,
   acesso_074 BIT,
   acesso_075 BIT,
   acesso_076 BIT,
   acesso_077 BIT,
   acesso_078 BIT,
   acesso_079 BIT,
   acesso_080 BIT,
   acesso_081 BIT,
   acesso_082 BIT,
   acesso_083 BIT,
   acesso_084 BIT,
   acesso_085 BIT,
   acesso_086 BIT,
   acesso_087 BIT,
   acesso_088 BIT,
   acesso_089 BIT,
   acesso_090 BIT,
   acesso_091 BIT,
   acesso_092 BIT,
   acesso_093 BIT,
   acesso_094 BIT,
   acesso_095 BIT,
   acesso_096 BIT,
   acesso_097 BIT,
   acesso_098 BIT,
   acesso_099 BIT,
   acesso_100 BIT
   );

Create Table mesas(
   codigo INTEGER,
   nome Varchar(20),
   hora Varchar(10),
   id Varchar(18)
   );

Create Table montagem(
   id Varchar(10),
   nome Varchar(30)
   );



Create Table movimento_bancario(
   id Varchar(10),
   banco INTEGER,
   data DateTime,
   historico Varchar(30),
   entrada Decimal(12,2),
   saida Decimal(12,2)
   );

Create Table materia_prima(
   codigo INTEGER,
   nome Varchar(20),
   unidade INTEGER,
   preco Decimal(10,2),
   qtd Decimal(12,3)
   );



Create Table produto_composto(
   id_produto Varchar(10),
   id_mprima INTEGER,
   quantidade Decimal(12,3)
   );

Create Table produtos(
   codigo Varchar(10),
   cbarra Varchar(15),
   nome_longo Varchar(40),
   nome_cupom Varchar(15),
   categoria INTEGER,
   scategoria INTEGER,
   imposto INTEGER,
   baixa BIT,
   qtd_estoq INTEGER,
   qtd_min INTEGER,
   qtd_max INTEGER,
   vlr_custo Decimal(12,2),
   vlr_venda Decimal(12,2),
   promocao BIT,
   pizza BIT,
   val_tm_001 Decimal(10,2),
   val_tm_002 Decimal(10,2),
   val_tm_003 Decimal(10,2),
   val_tm_004 Decimal(10,2),
   val_tm_005 Decimal(10,2),
   val_tm_006 Decimal(10,2)
   );


Create Table tamanhos(
   nome Varchar(15),
   pedacos INTEGER
   );

Create Table tcompra1(
   fornecedor INTEGER,
   forma_pag INTEGER,
   num_parc INTEGER,
   data_venc DateTime,
   dias_parc INTEGER,
   produto Varchar(10),
   qtd INTEGER,
   vlr_unit Decimal(12,2),
   num_doc Varchar(15)
   );

Create Table tcompra2(
   fornecedor INTEGER,
   forma_pag INTEGER,
   num_parc INTEGER,
   data_venc DateTime,
   dias_parc INTEGER,
   mat_prima INTEGER,
   qtd Decimal(12,3),
   vlr_unit Decimal(12,2),
   num_doc Varchar(15)
   );

Create Table temp_cpz(
   preco Decimal(10,2)
   );

Create Table temp_produtos(
   id_mesa Varchar(18),
   produto Varchar(10),
   nome Varchar(30),
   qtd INTEGER,
   unitario Decimal(10,2),
   subtotal Decimal(12,2)
   );

Create Table temp_pizzas(
   id_mesa Varchar(18),
   id_produto Varchar(10),
   sequencia Varchar(10),
   nome Varchar(20),
   tamanho Varchar(10),
   preco Decimal(10,2)
   );

Create Table tmp_tela(
   seq INTEGER,
   item Varchar(40),
   qtd INTEGER,
   unitario Decimal(10,2),
   subtotal Decimal(12,2)
   );

Create Table temp_vendas(
   seq INTEGER,
   id Varchar(15),
   tipo INTEGER,
   produto Varchar(10),
   preco Decimal(10,2),
   sequencia Varchar(10),
   nome Varchar(30),
   qtd INTEGER,
   unitario Decimal(10,2),
   subtotal Decimal(12,2)
   );



