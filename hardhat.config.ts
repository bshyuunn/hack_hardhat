import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
	  compilers: [
			{
				version: "0.8.24",
			},
      {
				version: "0.7.0",
			},
			{
				version: "0.4.17"
			},
	  ],
  },

  networks : {
    hardhat: {
      forking: {
        url: "https://eth.llamarpc.com",
      },
    },
    mainnet : {
      accounts : ["0x09196f01ffec8a0a22e178c9b755d6c6fd9ec323774eb5fd189dd3859dbc487a"],
      url : "https://eth.llamarpc.com"
    },
  },
};

export default config;
