[[eosio::on_notify("volentixgsys::transfer")]]
void wps::transfer( const eosio::name&    from,
                    const eosio::name&    to,
                    const eosio::asset&   quantity,
                    const string&  memo )
{
    require_auth( from );
     const eosio::name ram_payer = to;

    // // Only monitor incoming transfers to get_self() account
    if ( to != get_self() ) return;

    // exclude system account
    if ( from == "eosio.ram"_n || from == "eosio.stake"_n ) return;

    // funding WPS from designated system account
    // funding WPS using donations (memo="donate")
    if ( memo == "donate" || from == "eosio.names"_n || from == "eosio.ramfee"_n ) {
        if ( _state.exists() ) add_funding( quantity );
        return;
    }

    // is contract paused or not
    check_contract_active();

    // deposit quantity to account
     eosio::name deposit_to = from;
    
    // accept deposits from alternate account
    if ( memo.size() ) {
        check( is_account( name{ memo } ), "memo must be an active account name");
        deposit_to = name{ memo };
    }

    auto deposits_itr = _deposits.find( deposit_to.value );
    check( deposits_itr != _deposits.end(), "deposit account does not exist, must `submitdraft` action before sending funds to " + get_self().to_string());
    
    //add_deposit( deposit_to, quantity, ram_payer );
    add_liquid_deposits( quantity );
    
    auto deposits_itr2 = _deposits.find( from.value );

    _deposits.modify( deposits_itr2, get_self(), [&]( auto& row ) {
        row.balance += quantity;
        
    });
 
}
