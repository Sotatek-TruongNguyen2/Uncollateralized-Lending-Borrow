import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployJuniorRewards: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const { address: rewardAddress } =  await deploy("OvenueJuniorRewards", {
    from: deployer,
    args: [
        deployer,
        configAddress
    ],
    log: true,
    deterministicDeployment: false,
    proxy: {
        proxyContract: 'OpenZeppelinTransparentProxy',
        upgradeIndex: 0,
        methodName: 'initialize'
    },
  });

  await hre.addressExporter.save({
    OvenueJuniorRewards: rewardAddress,
  })
};

deployJuniorRewards.tags = ["REWARDS"];
deployJuniorRewards.dependencies = ["CONFIG"];

export default deployJuniorRewards;
