import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const seniorLP: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

  const { address: seniorLPAddress } =  await deploy("OvenueSeniorLP", {
    from: deployer,
    args: [
        deployer,
        "Ovenue Senior LP",
        "OSL",
        configAddress
    ],
    log: true,
    deterministicDeployment: false,
    proxy: {
        proxyContract: 'OpenZeppelinTransparentProxy',
        upgradeIndex: 0,
        methodName: '__initialize__'
    },
  });

  await hre.addressExporter.save({
    OvenueSeniorLP: seniorLPAddress,
  })
};

seniorLP.tags = ["SENIOR_LP"];
seniorLP.dependencies = ["CONFIG"];

export default seniorLP;
