import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployUniqueIdentity: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const { address: uniqueIdentityAddress } =  await deploy("UniqueIdentity", {
    from: deployer,
    args: [
        deployer,
        "https://unique.identity" // uri - 
    ],
    log: true,
    deterministicDeployment: false,
    proxy: {
        proxyContract: 'OpenZeppelinTransparentProxy',
        upgradeIndex: 0,
        methodName: 'initialize'
    }
  });

  await hre.addressExporter.save({
    OvenueUniqueIdentity: uniqueIdentityAddress,
  })
};

deployUniqueIdentity.tags = ["IDENTITY"];

export default deployUniqueIdentity;
