import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployBorrower: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer, platform } = await getNamedAccounts();

  const { address: borrowerAddress } =  await deploy("OvenueBorrower", {
    from: deployer,
    args: [],
    log: true,
    deterministicDeployment: false,
  });

  await hre.addressExporter.save({
    BorrowerImplementation: borrowerAddress,
  })
};

deployBorrower.tags = ["BORROWER"];

export default deployBorrower;
