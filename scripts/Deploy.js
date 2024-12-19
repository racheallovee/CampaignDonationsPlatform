const hre = require("hardhat");

async function main() {
  await hre.run("compile");

  // getting the contract factory for CharityDonationsPlatform
  const CharityDonationsPlatform = await hre.ethers.getContractFactory(
    "CharityDonationsPlatform"
  );

  //deploying the  the contract
  const charityDonationsPlatform = await CharityDonationsPlatform.deploy();

  //waiting for the deployment to complete
  await charityDonationsPlatform.waitForDeployment();

  //logs the contract address
  console.log(
    "CharityDonationsPlatform Contract Address:",
    await charityDonationsPlatform.getAddress()
  );
}

//executing the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
