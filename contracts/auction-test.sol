pragma solidity ^0.4.15;

//Auction susceptible to DoS attack
contract DosAuction {
    address currentFrontrunner;
    uint currentBid;

    //Takes in bid, refunding the frontrunner if they are outbid
    function bid() payable {
        require(msg.value > currentBid);

        //If the refund fails, the entire transaction reverts.
        //Therefore a frontrunner who always fails will win
        if (currentFrontrunner != 0) {
            //E.g. if recipients fallback function is j
            require(currentFrontrunner.send(currentBid));
        }

        currentFrontrunner = msg.sender;
        currentBid = msg.value;
    }
}

//Secure auction that cannot be DoS'
contract SecureAuction {
    address currentFrontrunner;
    uint currentBid;
    //Store refunds in mapping to avoid DoS
    mapping(address => uint) refunds;

    //Avoids "pushing" balance to users favoring "pull" architectue
    function bid() external payable {
        require(msg.value > currentBid);

        if (currentFrontrunner != 0) {
            refunds[currentFrontrunner] += currentBid;
        }

        currentFrontrunner = msg.sender;
        currentBid = msg.value;
    }

    //Allows users to get their refund from auction
    function withdraw() external {
        //Do all state manipulation before external call to
        //avoid reentrancy attack
        uint refund = refunds[msg.sender];
        refunds[msg.sender] = 0;

        msg.sender.send(refund);
    }
}
