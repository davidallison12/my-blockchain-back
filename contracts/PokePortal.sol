// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract PokePortal {
    uint256 totalPokeTeams;

    // Setting  private variable to help generate a random number 
    uint256 private seed; // NOTE : RANDOM NUMBERS ARE DIFFICULT IN SOLIDITY | CONTRACTS ARE PUBLIC MOST NUMEBRS COULD BE FIGURED OUT WITHOUT SOME WORK ON OUR END

    // Setting an event
    event NewPoke(address indexed from, uint256 timestamp, string message);

    // Creating a Struct
    // Which is a custom datatype where we can customize what we want to hold inside it

    struct NewPokeTeam {
        address trainer; // The address of the user who waved
        string message; // The message that was sent 
        uint256 timestamp; // The timestamp when the trainer sent it. 
    }

    // Declaring a variable "pokeTeams" that stores an array of structs.
    // This is what holds all of the pokeTeams anyone ever sends.

    NewPokeTeam[] pokeTeams;

    // This is an address => uint mapping
    // Can associate an address w/ number
    // Storing the address with the last time the user waved
    mapping(address => uint256) public lastDeclaredAt;


    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart. I'm alive!! What is your Pokemon team?");
        // SET INITIAL SEED
        // block.difficulty = tells miners how hard blcok will be to mine based on transactions in block
        // Blocks get harder for a # of reasons, but, mainly they get harder when there are more transactions in the block (some miners prefer easier blocks, but, these payout less).
        
        // block.timestamp =  is just the Unix timestamp that the block is being processed.

        seed = (block.timestamp + block.difficulty) % 100; // Combined both random numbers using modulo to get number b/w 0-100
    }


    function newPokeTeam(string memory _message) public { //Public is used so we can run functions in run.js file using ".deploy()"

        // Make sure current timestamp is at least 15 min bigger than last timestamp stored
        require(
            lastDeclaredAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );
        // UPDATE THE CURRENT TIMESTAMP WE HAVE FOR USER
        lastDeclaredAt[msg.sender] = block.timestamp;

        totalPokeTeams += 1;
        console.log("%s is ready for battle with their team!", msg.sender, _message);

        // This is where we actually store the poketeam data in the array
        pokeTeams.push(NewPokeTeam(msg.sender, _message, block.timestamp));

        // GENERATE NEW SEED FOR NEXT USER THAT SENDS WAVE
        seed = (block.difficulty + block.timestamp + seed) % 100; // Combine difficulty and timstamp again + added seed from above to make even more random number.

        // console.log("Random # generated: %d", seed);

        // Give a 50% chance that the user wins the prize.
        if(seed <= 50) { // Gives 50% chance to receive ether 
            console.log("%s won!", msg.sender);
            
            // Code to give money gose here 
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            ); // "require" takes 2 arguments: Condition for require to be true and consequence of it being false 
            (bool success,) = (msg.sender).call{value: prizeAmount}(""); //This is what sends the money
            require(success, "Failed to withdraw money from contract");
        }


        
        // This is where we are calling our event from line 11
        emit NewPoke(msg.sender, block.timestamp, _message);

        // Give others Money when transaction is callad

        // uint256 prizeAmount = 0.0001 ether;

        // require(
        //     prizeAmount <= address(this).balance,
        //     "Trying to withdraw more money than the contract has."
        // ); // "require" takes 2 arguments: Condition for require to be true and consequence of it being false 
        // (bool success,) = (msg.sender).call{value: prizeAmount}(""); //This is what sends the money
        // require(success, "Failed to withdraw money from contract");
    }
    // This will return the struct array pokeTeams to us. Makes easy to retrieve teams from website
    function getAllPokeTeams() public view returns (NewPokeTeam[] memory) {
        return pokeTeams;
    }

    function getTotalPokeTeams() public view returns (uint256) {
        console.log("We are %d Pokemon Teams strong!", totalPokeTeams);
        return totalPokeTeams;
    }

}

