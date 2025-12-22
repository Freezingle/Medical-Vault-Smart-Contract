import hre from "hardhat";

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with account:", deployer.address);

  const Vault = await hre.ethers.getContractFactory("MedicalRecordVault");
  const vault = await Vault.deploy();
  await vault.deployed();

  console.log("MedicalRecordVault deployed at:", vault.address);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
