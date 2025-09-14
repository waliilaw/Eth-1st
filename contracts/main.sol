// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;
    uint public entryFee = 0.1 ether;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value == entryFee, "Entry fee is 0.1 ether");
        players.push(msg.sender);
    }
    
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function pickWinner() public restricted {
        require(players.length > 0, "No players in lottery");
        
        uint index = random() % players.length;
        address payable winner = payable(players[index]);
        

        winner.transfer(address(this).balance);
        

        players = new address[](0);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this");
        _;
    }
}