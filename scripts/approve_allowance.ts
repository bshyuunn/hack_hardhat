// npx hardhat run scripts/approve_allowance.ts --network hardhat

import { ethers } from "hardhat";

async function main() {
    const accounts = await ethers.getSigners();
    const MyContract = await ethers.getContractFactory("TetherToken");
    const myContract = new ethers.Contract("0xdAC17F958D2ee523a2206206994597C13D831ec7", MyContract.interface, accounts[0]);

    const allowanceBefore = await myContract.allowance(accounts[0], "0xdAC17F958D2ee523a2206206994597C13D831ec7");
    console.log("allowanceBefore:", allowanceBefore);

    const approvalResult = await myContract.approve("0xdAC17F958D2ee523a2206206994597C13D831ec7", 38);
    console.log("approvalResult:", approvalResult?.blockNumber);

    const allowanceAfter = await myContract.allowance(accounts[0], "0xdAC17F958D2ee523a2206206994597C13D831ec7");
    console.log("allowanceAfter:", allowanceAfter);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
