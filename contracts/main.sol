//SPDX-License-MIT
pragma solidity ^0.8.0;

contract Lottery {

    event PlayerEntered(address player , uint amount);
    event WinnerPicked(address winner , uint prize);


    address public manager;
    address[] public players;
    uint public entryFee = 0.1 ether;

constructor() {
    manager = msg.sender;
}

function enter() public payable{
    require(msg.value == entryFee , "Entry Fee is 0.1 ETH");
    players.push(msg.sender);

    emit PlayerEntered(msg.sender , msg.value);
}

function viewPlayers() public view returns(address[] memory){ 
    return players;
}

function viewBalance() public view returns(uint){
    return address(this).balance;
}

function randomSelection() public view returns(uint){
    return uint(
        keccak256(abi.encodePacked(
            block.difficulty,
            block.timestamp,
            players
        )));
}

modifier onlyManager() {
    require(msg.sender == manager , "Only Founder can call this , hehe :]");
    _;
}

function pickWinner() public onlyManager{
    require(players.length > 0 , "No Player Found in the lobby , sed life :(");

    uint index = randomSelection() % players.length;
    address payable winner = payable(players[index]);
    uint prize = address(this).balance;

    winner.transfer(prize);
    emit WinnerPicked(winner , prize);

    players = new address[](0);
}


}