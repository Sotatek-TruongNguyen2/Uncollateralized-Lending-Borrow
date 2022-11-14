import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployJuniorPoolNonKYC: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  // const tranchingLogic = (await deployments.get("OvenueTranchingLogic")).address;
  // const ovenueJuniorPoolLogic = (await deployments.get("OvenueJuniorPoolLogic")).address;

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

  const { address: contractAddress } = await deploy("OvenueJuniorPoolNoneKYC", {
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
    OvenueJuniorPoolNonKYC: contractAddress,
  })
};

deployJuniorPoolNonKYC.tags = ["JUNIOR_POOL_NON_KYC"];

export default deployJuniorPoolNonKYC;
