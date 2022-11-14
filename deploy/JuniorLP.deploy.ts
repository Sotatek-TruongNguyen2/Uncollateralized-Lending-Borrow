import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const juniorLP: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const { address: juniorLPAddress } =  await deploy("OvenueJuniorLP", {
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
    OvenueJuniorLP: juniorLPAddress,
  })
};

juniorLP.tags = ["JUNIOR_LP"];
juniorLP.dependencies = ["CONFIG"];

export default juniorLP;
