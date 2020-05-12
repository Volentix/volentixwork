eosio-cpp -abigen vtxvtweights.cpp

cleos create account eosio vtxvtweights EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

cleos set account permission vtxvtweights active --add-code

# Reg prods
cleos set contract vtxvtweights ../vtxvtweights vtxvtweights.wasm vtxvtweights.abi -p vtxvtweights
