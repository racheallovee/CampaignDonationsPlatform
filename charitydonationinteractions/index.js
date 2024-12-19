import { ethers, Wallet } from "ethers";
import * as dotenv from "dotenv";
dotenv.config();
// import charityDonationsAbi from "./ABI/CharityDonationsPlatform.json" assert { type: "json" };

const createContractInstance = (contractAddress, contractAbi) => {
  const alchemyApiKey = process.env.ALCHEMY_API_KEY_SEPOLIA;
  const provider = new ethers.AlchemyProvider("sepolia", alchemyApiKey);
  console.log("Provider connected:", provider);

  const privateKey = process.env.WALLET_PRIVATE_KEY;
  const wallet = new Wallet(privateKey, provider);
  console.log("Wallet connected:", wallet.address);

  const contract = new ethers.Contract(contractAddress, contractAbi, wallet);
  console.log("Contract instance created:", contract.address);

  return contract;
};

// const contractAddress = "CONTRACT_ADDRESS_HERE"; 
// const contract = createContractInstance(
//   contractAddress,
//   charityDonationsAbi.abi
// );

//function to create a campaign
const createCampaign = async (title, description, targetAmount) => {
  try {
    const txResponse = await contract.createCampaign(
      title,
      description,
      targetAmount
    );
    console.log("Transaction Hash:", txResponse.hash);
    console.log(
      `Track on Etherscan: https://sepolia.etherscan.io/tx/${txResponse.hash}`
    );
    await txResponse.wait();
    console.log("Campaign created successfully!");
  } catch (error) {
    console.error("Error creating campaign:", error);
    throw error;
  }
};

//function to donate to a campaign
const donateToCampaign = async (campaignId, donationAmount) => {
  try {
    const txResponse = await contract.donateToCampaign(campaignId, {
      value: ethers.parseEther(donationAmount.toString()),
    });
    console.log("Transaction Hash:", txResponse.hash);
    console.log(
      `Track on Etherscan: https://sepolia.etherscan.io/tx/${txResponse.hash}`
    );
    await txResponse.wait();
    console.log("Donation successful!");
  } catch (error) {
    console.error("Error donating to campaign:", error);
    throw error;
  }
};

//function to withdraw funds from a campaign
const withdrawFunds = async (campaignId) => {
  try {
    const txResponse = await contract.withdrawFunds(campaignId);
    console.log("Transaction Hash:", txResponse.hash);
    console.log(
      `Track on Etherscan: https://sepolia.etherscan.io/tx/${txResponse.hash}`
    );
    await txResponse.wait();
    console.log("Funds withdrawn successfully!");
  } catch (error) {
    console.error("Error withdrawing funds:", error);
    throw error;
  }
};

// usage example
(async () => {
  // create a campaign
  await createCampaign(
    "Save the Rainforest",
    "Help us protect the rainforest by contributing to this campaign.",
    ethers.parseEther("5") // target amount in ether
  );

  //donate to a campaign
  await donateToCampaign(1, 1); //donate 1 ETH to campaign ID 1

  //withdraw funds from a campaign
  await withdrawFunds(1);
})();
