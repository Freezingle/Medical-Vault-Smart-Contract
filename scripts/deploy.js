import hre from 'hardhat'
import { error } from 'node:console'

async function main() {
  const [deployer] = await hre.ethers.getSigners()
  console.log('Deploying contracts with the account:', deployer.address)
    const Vault = await hre.ethers.getContractFactory('MedicalRecordVault')
    const vault = await Vault.deploy()
    await vault.waitForDeployment()
    address= vault.getAddress()
    console.log('MedicalRecordVault deployed to:',address)
  
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})