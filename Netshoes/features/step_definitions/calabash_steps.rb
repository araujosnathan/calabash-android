Dado(/^que estou na tela inicil do aplicativos$/) do
  touch "* id:'button1'"
  touch "* id:'button1'"
  element_exists "* id:'category_home_item_layout'"
end

Quando(/^eu clicar no campo de pesquisa$/) do
  touch "* id:'search_button'"
end

Quando(/^eu preencher o campo de pesquisa com "([^"]*)"$/) do |nome_produto|
  @produto = nome_produto
  keyboard_enter_text @produto
  press_enter_button
end

Entao(/^devo visualizar o produto pesquisado$/) do
  touch("* id:'generic_dialog_positive'")
  wait_for_element_exists("* id:'product_name'", timeout:10)
  status = false
  query("* id:'product_name'", :text).each do |text|
    status = text.downcase.include? @produto.downcase
    break if status == true
  end
  fail "Produto(s) não corresponde(m) com a pesquisa realizada!" unless status
end

Entao(/^devo visualizar tela de nenhum item encontrado$/) do
  wait_for_element_exists("* id:'empty_view_message'", timeout:10)
end
