import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployConfig: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts, ethers } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const { address: configAddress } =  await deploy("OvenueConfig", {
    from: deployer,
    args: [
        deployer
    ],
    log: true,
    deterministicDeployment: false,
    proxy: {
        proxyContract: 'OpenZeppelinTransparentProxy',
        upgradeIndex: 0,
        methodName: 'initialize'
    },
  });

  const OvenueConfig = await ethers.getContractFactory("OvenueConfig");
  const ovenueConfig = await OvenueConfig.attach(configAddress);

  const EXCHANGE_ADDRESS = process.env.EXCHANGE_ADDRESS || undefined;

  if (EXCHANGE_ADDRESS) {
    const tx = await ovenueConfig.setAddress(
      18, // ovenue exchange index
      EXCHANGE_ADDRESS
    );
  }

  await hre.addressExporter.save({
    OvenueConfig: configAddress,
  })
};

deployConfig.tags = ["CONFIG"];

export default deployConfig;
