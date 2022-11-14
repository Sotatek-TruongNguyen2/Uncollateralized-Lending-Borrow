import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployJuniorPool: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const { address: tranchingLogic } =  await deploy("OvenueTranchingLogic", {
    from: deployer,
    args: [],
    log: true,
    deterministicDeployment: false,
  });

  const { address: ovenueJuniorPoolLogic } =  await deploy("OvenueJuniorPoolLogic", {
    from: deployer,
    args: [],
    libraries: {
      OvenueTranchingLogic: tranchingLogic
    },
    log: true,
    deterministicDeployment: false,
  });

  const { address: contractAddress } = await deploy("OvenueJuniorPool", {
    from: deployer,
    args: [],
    libraries: {
        OvenueTranchingLogic: tranchingLogic,
        OvenueJuniorPoolLogic: ovenueJuniorPoolLogic
    },
    log: true,
    deterministicDeployment: false,
  });

  await hre.addressExporter.save({
    OvenueJuniorPool: contractAddress,
  })
};

deployJuniorPool.tags = ["JUNIOR_POOL"];
deployJuniorPool.skip = () => Promise.resolve(true);

export default deployJuniorPool;
