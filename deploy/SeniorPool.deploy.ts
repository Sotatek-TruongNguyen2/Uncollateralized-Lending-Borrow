import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deploySeniorPool: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const accountantAddress = (await deployments.get("Accountant")).address;
  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;
  
  const { address: seniorPoolAddress } =  await deploy("OvenueSeniorPool", {
    from: deployer,
    args: [
        deployer,
        configAddress
    ],
    log: true,
    deterministicDeployment: false,
    proxy: {
        proxyContract: 'OpenZeppelinTransparentProxy',
        methodName: 'initialize'
    },
    libraries: {
        Accountant: accountantAddress
    },
  });

  await hre.addressExporter.save({
    OvenueSeniorPool: seniorPoolAddress,
  })
};

deploySeniorPool.tags = ["SENIOR_POOL"];
deploySeniorPool.dependencies = ["CONFIG", "JUNIOR_POOL", "USDC"];
deploySeniorPool.skip = () => Promise.resolve(true);

export default deploySeniorPool;
