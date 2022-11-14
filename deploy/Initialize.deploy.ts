import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { expandTo18Decimals, expandTo18DecimalsRaw } from "../test/utils/utilities";

const initialize: DeployFunction = async (
    hre: HardhatRuntimeEnvironment
) => {
    const { deployments, getNamedAccounts, ethers } = hre;
    const { deploy } = deployments;
    const { deployer, platform } = await getNamedAccounts();

    const identityAddress = (await deployments.get("UniqueIdentity_Proxy")).address;
    const configProxyAddress = (await deployments.get("OvenueConfig_Proxy")).address;
    const creditLineAddress = (await deployments.get("CreditLine")).address;
    const juniorPoolAddress = (await deployments.get("OvenueJuniorPoolNoneKYC")).address;
    const borrowerAddress = (await deployments.get("OvenueBorrower")).address;
    const seniorStrategyAddress = (await deployments.get("FixedLeverageRatioStrategy_Proxy")).address;
    const juniorLPAddress = (await deployments.get("OvenueJuniorLP_Proxy")).address;
    const goAddress = (await deployments.get("Go_Proxy")).address;
    const seniorPoolAddress = (await deployments.get("OvenueSeniorPoolNoneKYC_Proxy")).address;
    const seniorLPAddress = (await deployments.get("OvenueSeniorLP_Proxy")).address;
    const factoryAddress = (await deployments.get("OvenueFactory_Proxy")).address;
    const rewardAddress = (await deployments.get("OvenueJuniorRewards_Proxy")).address;
    const collateralCustodyAddress = (await deployments.get("OvenueCollateralCustody_Proxy")).address;
    const usdcAddress = process.env.USDC_ADDRESS || "";
    const exchangeAddress = process.env.EXCHANGE_ADDRESS || "";

    const OvenueConfig = await ethers.getContractFactory("OvenueConfig");
    const ovenueConfig = await OvenueConfig.attach(configProxyAddress);

    const SeniorLP = await ethers.getContractFactory("OvenueSeniorLP");
    const ovenueSeniorLP = await SeniorLP.attach(seniorLPAddress);

    await ovenueConfig.setCreditLineImplementation(
        creditLineAddress
    );

    await ovenueConfig.setTranchedPoolImplementation(
        juniorPoolAddress
    );

    await ovenueConfig.setBorrowerImplementation(
        borrowerAddress
    );

    await ovenueConfig.setSeniorPoolStrategy(
        seniorStrategyAddress
    );

    await ovenueConfig.setOvenueConfig(
        configProxyAddress
    );
    
    await ovenueConfig.setTreasuryReserve(
        deployer
    );

    await ovenueSeniorLP.grantRole(
        await ovenueSeniorLP.MINTER_ROLE(),
        seniorPoolAddress
    );

    // set withdraw fee denominator
    await ovenueConfig.setNumber(4, 200);
    // set reserve fee denominator
    await ovenueConfig.setNumber(3, 10);
    // // set junior pool LP  address
    await ovenueConfig.setAddress(2, seniorLPAddress);
    // // set junior pool LP  address
    await ovenueConfig.setAddress(8, juniorLPAddress);
    // set Go address
    await ovenueConfig.setAddress(13, goAddress);
    // set Senior pool
    await ovenueConfig.setAddress(9, seniorPoolAddress);
    // set Ovenue Factory
    await ovenueConfig.setAddress(1, factoryAddress);
    // set Protocol admin
    await ovenueConfig.setAddress(6, deployer);
    // set Leverage ratio - 4X
    await ovenueConfig.setNumber(9, expandTo18Decimals(4, 18));
    // // set Drawdown period in seconds - 5 days
    await ovenueConfig.setNumber(7, 5 * 24 * 60 * 60);
    // // set Junior rewards
    await ovenueConfig.setAddress(14, rewardAddress);
    // Collateral custody
    await ovenueConfig.setAddress(16, collateralCustodyAddress);
    // set collateral token
    await ovenueConfig.setAddress(15, usdcAddress);
    // set ovenue exchange
    await ovenueConfig.setAddress(18, exchangeAddress);

    await ovenueConfig.addToGoList(seniorPoolAddress);

    console.log("DONE INITIALIZATION!")

    await hre.addressExporter.save({
        OvenueSeniorPool: seniorPoolAddress,
        OvenueConfig: configProxyAddress,
        OvenueFactory: factoryAddress,
        OvenueJuniorPoolImpl: juniorPoolAddress,
        OvenueJuniorLP: juniorLPAddress,
        OvenueSeniorLP: seniorLPAddress,
        OvenueGo: goAddress,
        OvenueUniqueIdentity: identityAddress,
        OvenueCreditLine: creditLineAddress,
        OvenueJuniorRewards: rewardAddress,
        OvenueCollateralCustody: collateralCustodyAddress,
        OvenueSeniorStrategy: seniorStrategyAddress,
        USDC: usdcAddress
    })
};

initialize.runAtTheEnd = true;

export default initialize;
