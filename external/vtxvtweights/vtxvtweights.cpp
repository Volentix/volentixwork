#pragma once

#include <eosio/asset.hpp>
#include <eosio/eosio.hpp>
#include <eosio/singleton.hpp>

#include <string>

using namespace eosio;
using namespace std;


class [[eosio::contract("vtxvtweights")]] vtxvtweights : public contract {
    public:
        using contract::contract;

        vtxvtweights( name receiver, name code, eosio::datastream<const char*> ds )
            : contract( receiver, code, ds ),
                _weights( _self, _self.value ){}


        struct [[eosio::table("weights"), eosio::contract("vtxvtweights")]] weights {
            map<asset, int> by_price = {};
        };

        typedef eosio::singleton< "weights"_n, weights> weights_table;

        [[eosio::action]]
        void setweights(map<asset, int> by_price) {
            require_auth(_self);

            auto params = weights{
                .by_price = by_price
            };

            _weights.set( params, _self );
        };

        using setweights_action = eosio::action_wrapper<"setweights"_n, &vtxvtweights::setweights>;
    private:
        weights_table              _weights;
};

