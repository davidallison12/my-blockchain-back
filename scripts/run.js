// const main = async () => {
//   const [owner, randomPerson] = await hre.ethers.getSigners(); // Grabs address of contract owner and a randome wallet repectively
//   const pokeContractFactory = await hre.ethers.getContractFactory("PokePortal"); // Compiles contract and generate files needed to work with contract in artifacts directory
//   const pokeContract = await pokeContractFactory.deploy(); // creates local Etherum network and destroys after script is run
//   await pokeContract.deployed(); // Once deployed our WavePortal constructor will run
//   console.log("Contract address: ", pokeContract.address); // Getting the address of deployed contract

//   // console.log("Contract deployed by: ", owner.address) // Address of person deploying our contract

//   let pokeCount;
//   pokeCount = await pokeContract.getTotalPokeTeams(); // Grabs total waves
//   console.log(pokeCount.toNumber());

//   // Sending waves
//   let pokeTxn = await pokeContract.newPokeTeam("Pikachu"); // Waves
//   await pokeTxn.wait(); //Wait for transaction to be mined

//   const [_, randomPokemon] = await hre.ethers.getSigners();
//   pokeTxn = await pokeContract.connect(randomPerson).newPokeTeam("Charmander");
//   await pokeTxn.wait(); // Wait for the transaction to be mined

//   let allPokeTeams = await pokeContract.getAllPokeTeams();
//   console.log(allPokeTeams);

//   //     pokeCount = await pokeContract.getTotalPokeTeams() // Grabs total waves

//   //     pokeTxn = await pokeContract.connect(randomPerson).newPokeTeam()
//   //     await pokeTxn.wait()

//   //     pokeCount = await pokeContract.getTotalPokeTeams()
// };

const main = async () => {
    const pokeContractFactory = await hre.ethers.getContractFactory("PokePortal"); // Compiles contract and generate files needed to work with contract in artifacts directory
    const pokeContract = await pokeContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"), 
    }) // This is what funds out project with 0.1 ETH
    await pokeContract.deployed()
    console.log("Contract Address: ", pokeContract.address)

    // ======================
    // GET CONTRACT BALANCE
    // ======================

    
    let contractBalance = await hre.ethers.provider.getBalance(pokeContract.address) // Gets the balance from the contracts address
    console.log("Contract balance: ", hre.ethers.utils.formatEther(contractBalance)) //Checks to see what the balance is. 
    
    
    // ======================
    // SEND POKEMON
    // ======================
    
    let pokeTxn = await pokeContract.newPokeTeam("Plusal")
    await pokeTxn.wait()
    
    // let pokeTxn2 = await pokeContract.newPokeTeam("Minum")
    // await pokeTxn2.wait()

    // =========================================
    // GET CONTRACT BALANCE TO SEE WHAT HAPPENED
    // =========================================

    contractBalance = await ethers.provider.getBalance(pokeContract.address)
    console.log("Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
    )

    let allPokemon = await pokeContract.getAllPokeTeams()
    console.log(allPokemon)

}   


const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
