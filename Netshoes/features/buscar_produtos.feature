# language: pt

Funcionalidade: Buscar Produto
  Contexto: Tela inicial do aplicativo Netshoes
  Dado que estou na tela inicil do aplicativos

  @valid
  Cenario: Buscar um produto valido com nome especifico
    Quando eu clicar no campo de pesquisa
    E eu preencher o campo de pesquisa com "ADIDAS"
    Entao devo visualizar o produto pesquisado

  @invalid
  Cenario: Buscar um produto invalido com nome especifico
    Quando eu clicar no campo de pesquisa
    E eu preencher o campo de pesquisa com "qwerty"
    Entao devo visualizar tela de nenhum item encontrado
