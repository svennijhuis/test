/ SPDX-License-Identifier: GPL-3.0

// Solidity version 
pragma solidity >= 0.8.0 < 0.9.0;

// Create contract here
contract HelloWorld{
    // owner address 
    address payable private owner;
    uint public positive_number;
    uint public myAnswerNumber;
    string right_answer = "You guessed right";
    string wrong_answer = "You guessed wrong";
    // make a array
    uint[] attempts;

    // Create constructor here
    constructor(uint _guessNumber){
        // owner address in a field
        owner = payable(msg.sender)
        myAnswerNumber = _guessNumber;
    }

    // method anyone call to guess number
    function _setGuessNumber(uint _newNumber) public returns (string 
memory){
        positive_number = _newNumber;
        if(positive_number == myAnswerNumber){
            return right_answer;
        }
        else {
            attempts.push(positive_number);
            return wrong_answer;
        }
    }
    // store all attemps
    function getAllGuesses() public view returns(uint256[] memory){
        return attempts;
    }
}

