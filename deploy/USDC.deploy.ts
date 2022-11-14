import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployUSDC: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, execute } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configProxyAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const OvenueConfig = await ethers.getContractFactory("OvenueConfig");
  const ovenueConfig = await OvenueConfig.attach(configProxyAddress);
  const USDC_ADDRESS = process.env.USDC_ADDRESS || undefined;

  if (USDC_ADDRESS) {
    const tx = await ovenueConfig.setAddress(
      3, // usdc index
      USDC_ADDRESS
    );
  
  //   await execute(
  //     "OvenueConfig_Proxy", 
  //     { 
  //       from: deployer, 
  //       gasLimit: "300000", 
  //       log: true
  //     }, 
  //     "setAddress", 
  //     3, // usdc index
  //     usdcAddress
  //   )
  
    await hre.addressExporter.save({
      USDC: USDC_ADDRESS,
    })
  }
};

deployUSDC.tags = ["USDC"];
deployUSDC.dependencies = ["CONFIG"];

export default deployUSDC;
