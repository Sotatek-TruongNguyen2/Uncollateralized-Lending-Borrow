import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deploySeniorPoolNonKYC: DeployFunction = async (
    hre: HardhatRuntimeEnvironment
) => {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;
    const { deployer, platform } = await getNamedAccounts();

    const accountantAddress = (await deployments.get("Accountant")).address;
    const configAddress = (await deployments.get("OvenueConfig_Proxy")).address;

    const { address: seniorPoolAddress } = await deploy("OvenueSeniorPoolNoneKYC", {
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

deploySeniorPoolNonKYC.tags = ["SENIOR_POOL_NON_KYC"];
deploySeniorPoolNonKYC.dependencies = ["CREDIT_LINE"];

export default deploySeniorPoolNonKYC;
