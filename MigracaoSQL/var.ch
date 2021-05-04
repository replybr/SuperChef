         public l_demo            := .F.
         public _limite_registros := 10
         public _nome_cliente_    := 'Q-Pizza Pizzaria'
         public _numero_serie_    := 'SCP62431348BR'
         public __codigo_cliente  := 0
         public _codigo_usuario_  := 0
         public _nome_usuario_    := space(10)
         public _tipo_cobranca    := 0
         public _zero             := 0
         
         public _tamanho_001 := ''
         public _tamanho_002 := ''
         public _tamanho_003 := ''
         public _tamanho_004 := ''
         public _tamanho_005 := ''
         public _tamanho_006 := ''
         public _pedaco_001  := 0
         public _pedaco_002  := 0
         public _pedaco_003  := 0
         public _pedaco_004  := 0
         public _pedaco_005  := 0
         public _pedaco_006  := 0
         
         public path_dbf     := GetStartUpFolder() + '\tabelas\'
         public path_imagens := GetStartUpFolder() + '\imagens\'

         * cores para labels, botões e janelas
         public _branco_001     := {255,255,255}
         public _preto_001      := {000,000,000}
         public _azul_001       := {108,108,255}
         public _azul_002       := {000,000,255}
         public _azul_003       := {032,091,164}
         public _azul_004       := {023,063,115}
         public _azul_005       := {071,089,135}
         public _azul_006       := {000,073,148}
         public _laranja_001    := {255,163,070}
         public _verde_001      := {000,094,047}
         public _verde_002      := {000,089,045}
         public _cinza_001      := {128,128,128}
         public _cinza_002      := {192,192,192}
         public _cinza_003      := {229,229,229}
         public _cinza_004      := {226,226,226}
         public _cinza_005      := {245,245,245}
         public _vermelho_001   := {255,000,000}
         public _vermelho_002   := {160,000,000}
         public _vermelho_003   := {190,000,000}
         public _amarelo_001    := {255,255,225}
         public _amarelo_002    := {255,255,121}
         public _marrom_001     := {143,103,080}
         public _ciano_001      := {215,255,255}
         public _grid_001       := _branco_001
         public _grid_002       := {210,233,255}
         public _super          := {128,128,255}
         public _acompanhamento := {255,255,220}

         * cores para get
         public _fundo_get   := {255,255,255}
         public _letra_get_1 := {000,000,255}
         
         * variáveis de apoio
         public _nome_unidade := 0
         public a_onde        := {'Delivery','Mesa','Balcão'}
         public a_situacao    := {'Montando','Assando','Sendo entregue','PEDIDO OK'}
         