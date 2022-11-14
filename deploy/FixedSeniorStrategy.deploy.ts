import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployFixedStrategy: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const { address: strategyAddress } =  await deploy("FixedLeverageRatioStrategy", {
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
    FixedSeniorStrategy: strategyAddress,
  })
};

deployFixedStrategy.tags = ["STRATEGY"];
deployFixedStrategy.dependencies = ["CONFIG"];

export default deployFixedStrategy;
