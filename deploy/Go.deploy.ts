import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployGO: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;
  const uniqueIdentityAddress = (await deployments.get("UniqueIdentity_Proxy")).address;

  const { address: goAddress } =  await deploy("Go", {
    from: deployer,
    args: [
        deployer,
        configAddress,
        uniqueIdentityAddress 
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
    Go: goAddress,
  })
};

deployGO.tags = ["GO"];
deployGO.dependencies = ["CONFIG", "IDENTITY"];

export default deployGO;
