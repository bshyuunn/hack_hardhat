// npx hardhat run scripts/balance_of.ts --network mainnet

import { ethers } from "hardhat";

async function main() {
    const accounts = await ethers.getSigners();
    const MyContract = await ethers.getContractFactory("TetherToken");
    const myContract = new ethers.Contract("0xdAC17F958D2ee523a2206206994597C13D831ec7", MyContract.interface, accounts[0]);

    const balance = await myContract.balanceOf("0xdAC17F958D2ee523a2206206994597C13D831ec7");

    console.log("Balance:", balance);
}

main()
