import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployCollateralCustody: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const { address: exchangeHelper } =  await deploy("OvenueExchangeHelper", {
    from: deployer,
    args: [],
    log: true,
    deterministicDeployment: false,
  });

  const { address: custodyLogic } =  await deploy("OvenueCollateralCustodyLogic", {
    from: deployer,
    args: [],
    log: true,
    deterministicDeployment: false,
  });

  const { address: custodyAddress } =  await deploy("OvenueCollateralCustody", {
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
    libraries: {
      OvenueExchangeHelper: exchangeHelper,
      OvenueCollateralCustodyLogic: custodyLogic
    }
  });

  await hre.addressExporter.save({
    OvenueCollateralCustody: custodyAddress,
  })
};

deployCollateralCustody.tags = ["CUSTODY"];
deployCollateralCustody.dependencies = ["CONFIG"];

export default deployCollateralCustody;
