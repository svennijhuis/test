pragma solidity ^0.4.15;

contract DosAuction {
    address currentFrontrunner;
    uint currentBid;

    function bid() payable {
        require(msg.value > currentBid);

        //Therefore a frontrunner who always fails will win
        if (currentFrontrunner != 0) {
            //E.g. if recipients fallback function is just revert()
            require(currentFrontrunner.send(currentBid));
        }

        currentFrontrunner = msg.sender;
        currentBid = msg.value;
    }
}

contract SecureAuction {
    address currentFrontrunner;
    uint currentBid;
    //Store refunds in mapping to avoid DoS
    mapping(address => uint) refunds;

    //Avoids "pushing" balance to users favoring "pull" architecture
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
