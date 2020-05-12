# First deploy the weights contract


cleos create account eosio wps EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio vdexdposvote EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

cleos set account permission wps active --add-code
cleos set account permission vdexdposvote active --add-code

# Reg prods
cleos set contract vdexdposvote ./external/vdexdposvote vdexdposvote.wasm vdexdposvote.abi -p vdexdposvote

cleos create account eosio prod1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio prod2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos push action vdexdposvote regproducer '[prod1, "prod1", "url", "key", "node_id", [1,2,3]]' -p prod1
cleos push action vdexdposvote regproducer '[prod2, "prod2", "url", "key", "node_id", [1,2,3]]' -p prod2

cleos push action volentixgsys transfer '["bob", "prod1", "2.00000000 VTX", "for vote"]' -p bob

cleos push action vdexdposvote voteproducer '[prod1, [prod2]]' -p prod1
cleos push action vdexdposvote voteproducer '[prod2, [prod1]]' -p prod1


bash scripts/build.sh && cleos set contract wps ./dist volentixwork.wasm volentixwork.abi

# Init contract

# Transfer first month budget
cleos push action volentixgsys transfer '["bob", "wps", "10.00000000 VTX", "donate"]' -p bob

cleos -v push action wps init '[{"vote_margin": 2, "deposit_required": "1.00000000 VTX", "voting_interval": 86400, "max_monthly_budget": "10.00000000 VTX", "min_time_voting_end": 0 }]' -p wps

# set proposer
cleos -v push action wps setproposer '["bob", [{"key":"region", "value":"global"}]]' -p bob

# propose draft
cleos -v push action wps submitdraft '["bob", "mywps", "My WPS", "6.00000000 VTX", 2, [{"key":"region", "value":"global"}]]' -p bob

# # cancel draft
# cleos -v push action wps canceldraft '["bob", "mywps"]' -p bob

# # modify draft
# cleos -v push action wps modifydraft '["bob", "mywps", "My WPS", [{"key":"category", "value":"other"}]]' -p bob

# deposit VTX into account
cleos push action volentixgsys transfer '["bob", "wps", "1.00000000 VTX", ""]' -p bob

# activate
cleos -v push action wps activate '["bob", "mywps", null]' -p bob

# vote --> prod1 is producer in vdexdposvote
cleos -v push action wps vote '["prod1", "mywps", "yes"]' -p prod1

# change bp vote & refresh
#here it possible update prods in vdexdposvote then refresh wps contract
cleos push action wps refresh '[]' -p myaccount

# # complete
cleos push action wps complete '[]' -p bob
