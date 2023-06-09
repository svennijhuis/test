pragma solidity ^0.8.0;

contract SecureAuctiona {
    address payable public currentFrontrunner;
    uint public currentBid;
    mapping(address => uint) public refunds;

    event BidPlaced(address bidder, uint bidAmount);
    event RefundClaimed(address bidder, uint refundAmount);

    function bid() external payable {
        require(
            msg.value > currentBid,
            "Bid amount must be higher than current b"
        );

        if (currentFrontrunner != address(0)) {
            refunds[currentFrontrunner] += currentBid;
        }

        currentFrontrunner = payable(msg.sender);
        currentBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() external {
        uint refund = refunds[msg.sender];
        require(refund > 0, "No refund available");

        refunds[msg.sender] = 0;
        payable(msg.sender).transfer(refund);

        emit RefundClaimed(msg.sender, refund);
    }
}
