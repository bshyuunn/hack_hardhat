import {ethers} from "hardhat";

const wallet = ethers.Wallet.createRandom();
console.log("wallet", wallet.privateKey);