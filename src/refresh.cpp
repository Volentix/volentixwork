[[eosio::action]]
void wps::refresh( )
{
    // update `votes` from eligible voters
    // any existing votes with voters with less than 100 EOS vpay will be removed
    check( refresh_proposals(), "nothing was modified");

    // update `proposals::eligible` field for all active proposals
    update_eligible_proposals();
}

bool wps::refresh_proposals()
{
    set<name> eligible_producers = get_eligible_producers();
    bool modified = false;

    for ( auto proposal_name : group_proposals( "active"_n ) ) {
        if ( refresh_proposal( proposal_name, eligible_producers ) ) modified = true;
    }
    return modified;
}

bool wps::refresh_proposal( const name proposal_name, const set<name> eligible_producers )
{
    auto votes_itr = _votes.find( proposal_name.value );
    map<name, name> votes = votes_itr->votes;
    bool modified = false;

    // iterate over each vote
    for (std::pair<eosio::name, eosio::name> item : votes) {
        const name voter = item.first;

        // remove votes from voters not eligible
        if ( eligible_producers.find( voter ) == eligible_producers.end() ) {
            votes.erase( voter );
            modified = true;
        }
    }
    // modify table
    if ( modified ) {
        _votes.modify( votes_itr, same_payer, [&]( auto& row ) {
            row.votes = votes;
            update_total_net_votes( proposal_name, row.votes );
        });
    }
    return modified;
}

bool wps::is_voter_eligible( const name voter )
{
    // TODO Так тут пререстроить на их контракт
    vdexdposvote::producers_table _producers( "vdexdposvote"_n, "vdexdposvote"_n.value );

    auto itr = _producers.find( voter.value );

    if ( itr->total_votes >= 0 ) return true; // TODO Set the eligible vote amount
    return false;
}

set<name> wps::get_eligible_producers()
{
    vdexdposvote::producers_table _producers( "vdexdposvote"_n, "vdexdposvote"_n.value );
    auto producer_by_votes = _producers.get_index<"prototalvote"_n>();

    set<name> eligible_producers;

    for ( auto row : producer_by_votes ) {
        if ( is_voter_eligible( row.owner )) eligible_producers.insert( row.owner );
        else break;
    }
    return eligible_producers;
}