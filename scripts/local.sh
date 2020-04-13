cleos create account eosio wpsvt EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos set account permission wpsvt active --add-code

bash scripts/build.sh && cleos set contract wpsvt ./dist volentixwork.wasm volentixwork.abi

# Transfer first month budget
bash scripts/build.sh && cleos set contract wpsvt ./dist volentixwork.wasm volentixwork.abi

# Init contract
cleos -v push action wpsvt init '[{"vote_margin": 2, "deposit_required": "1.00000000 VTX", "voting_interval": 86400, "max_monthly_budget": "10.00000000 VTX", "min_time_voting_end": 0 }]' -p wpsvt

# set proposer
cleos -v push action wpsvt setproposer '["bob", [{"key":"region", "value":"global"}]]' -p bob

# propose draft
cleos -v push action wpsvt submitdraft '["bob", "mywps", "My WPS", "6.00000000 VTX", 2, [{"key":"region", "value":"global"}]]' -p bob

# # cancel draft
# cleos -v push action wpsvt canceldraft '["bob", "mywps"]' -p bob

# # modify draft
# cleos -v push action wpsvt modifydraft '["bob", "mywps", "My WPS", [{"key":"category", "value":"other"}]]' -p bob

# deposit VTX into account
cleos push action volentixgsys transfer '["bob", "wpsvt", "1.00000000 VTX", ""]' -p bob

# activate
cleos -v push action wpsvt activate '["bob", "mywps", null]' -p bob

# vote --> prod1 is producer in vdexdposvote
cleos -v push action wpsvt vote '["prod1", "mywps", "yes"]' -p prod1

# change bp vote & refresh
#here it possible update prods in vdexdposvote then refresh wps contract
cleos push action wpsvt refresh '[]' -p myaccount

# # complete
cleos push action wpsvt complete '[]' -p bob
