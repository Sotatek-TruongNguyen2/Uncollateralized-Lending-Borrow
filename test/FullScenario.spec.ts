import { expect } from "chai";
import { ethers, upgrades } from "hardhat";
import { loadFixture, time, mine } from "@nomicfoundation/hardhat-network-helpers";
import { expandTo18Decimals, expandTo18DecimalsRaw } from "./utils/utilities";
import { buildUIDIssuanceSignature } from "../scripts/UID";
import { buildDepositSignature } from "../scripts/depositWithPermit";
import CollateralCustodyJSON from "../abi/contracts/core/OvenueCollateralCustody.sol/OvenueCollateralCustody.json";
import ERC721JSON from "../abi/contracts/external/ERC721PresetMinterPauserAutoId.sol/ERC721PresetMinterPauserAutoIdUpgradeSafe.json";

const DAY_IN_SECONDS = 24 * 60 * 60;
const ONE_YEAR = DAY_IN_SECONDS * 365;
const paymentPeriodInDays = 1; // 1 day
const termInDays = 30; // 30 day
const principalGracePeriodInDays = 1;
const fundableAt = Math.floor(new Date().getTime() / 1000) + DAY_IN_SECONDS;

describe("Lending/Borrow", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployAllLendingContracts() {
    const [owner, treasury, borrower, fstInvestor, secInvestor, tidInvestor] =
      await ethers.getSigners();

    // ============ Libraries =============== /
    const GovernanceLogic = await ethers.getContractFactory(
      "OvenueCollateralGovernanceLogic"
    );
    const governanceLogic = await GovernanceLogic.deploy();

    const Governance = await ethers.getContractFactory(
      "OvenueCollateralGovernance",
      {
        libraries: {
          OvenueCollateralGovernanceLogic: governanceLogic.address,
        },
      }
    );
    const governanceImpl = await Governance.deploy();

    const OvenueCollateralCustodyLogic = await ethers.getContractFactory(
      "OvenueCollateralCustodyLogic"
    );
    const ovenueCollateralCustodyLogic =
      await OvenueCollateralCustodyLogic.deploy();

    const OvenueExchangeHelper = await ethers.getContractFactory(
      "OvenueExchangeHelper"
    );
    const exchangeHelper = await OvenueExchangeHelper.deploy();

    const TranchingLogic = await ethers.getContractFactory(
      "OvenueTranchingLogic"
    );
    const tranchingLogic = await TranchingLogic.deploy();

    const Accountant = await ethers.getContractFactory("Accountant");
    const accountant = await Accountant.deploy();

    // ============ Logic & Implementation =============== /

    const JuniorPoolLogic = await ethers.getContractFactory(
      "OvenueJuniorPoolLogic",
      {
        libraries: {
          OvenueTranchingLogic: tranchingLogic.address,
        },
      }
    );
    const juniorPoolLogic = await JuniorPoolLogic.deploy();

    const JuniorPool = await ethers.getContractFactory("OvenueJuniorPool", {
      libraries: {
        OvenueTranchingLogic: tranchingLogic.address,
        OvenueJuniorPoolLogic: juniorPoolLogic.address,
      },
    });
    const juniorPool = await JuniorPool.deploy();

    // ============ Main contract ================

    const CreditLine = await ethers.getContractFactory("CreditLine", {
      libraries: {
        Accountant: accountant.address,
      },
    });
    const creditLine = await CreditLine.deploy();

    const BorrowerImpl = await ethers.getContractFactory("OvenueBorrower");
    const borrowerImpl = await BorrowerImpl.deploy();

    const Config = await ethers.getContractFactory("OvenueConfig");
    const config = await upgrades.deployProxy(Config, [owner.address]);

    const FixedSeniorStrategy = await ethers.getContractFactory(
      "FixedLeverageRatioStrategy"
    );
    const fixedSeniorStrategy = await upgrades.deployProxy(
      FixedSeniorStrategy,
      [owner.address, config.address]
    );

    const USDC = await ethers.getContractFactory("FiatTokenV2");
    const usdc = await upgrades.deployProxy(USDC, [
      "USD Coin",
      "USDC",
      "USDC",
      6,
      owner.address,
      owner.address,
      owner.address,
      owner.address,
    ]);

    // USDC index
    await config.setAddress(3, usdc.address);

    const JuniorRewards = await ethers.getContractFactory(
      "OvenueJuniorRewards"
    );
    const juniorRewards = await upgrades.deployProxy(JuniorRewards, [
      owner.address,
      config.address,
    ]);

    const JuniorLP = await ethers.getContractFactory("OvenueJuniorLP");
    const juniorLP = await upgrades.deployProxy(JuniorLP, [
      owner.address,
      config.address,
    ]);

    const SeniorPool = await ethers.getContractFactory("OvenueSeniorPool", {
      libraries: {
        Accountant: accountant.address,
      },
    });
    const seniorPool = await upgrades.deployProxy(
      SeniorPool,
      [owner.address, config.address],
      {
        unsafeAllow: ["external-library-linking"],
      }
    );

    const UniqueIdentity = await ethers.getContractFactory("UniqueIdentity");
    const uniqueIdentity = await upgrades.deployProxy(UniqueIdentity, [
      owner.address,
      "https://unique.identity",
    ]);

    await uniqueIdentity.setSupportedUIDTypes(
      [1, 2, 3, 4],
      [true, true, true, true]
    );

    const Go = await ethers.getContractFactory("Go");
    const go = await upgrades.deployProxy(Go, [
      owner.address,
      config.address,
      uniqueIdentity.address,
    ]);

    const SeniorLP = await ethers.getContractFactory("OvenueSeniorLP");
    const seniorLP = await upgrades.deployProxy(
      SeniorLP,
      [owner.address, "Ovenue Senior LP", "OSL", config.address],
      {
        initializer: "__initialize__",
      }
    );

    await seniorLP
      .connect(owner)
      .grantRole(await seniorLP.MINTER_ROLE(), seniorPool.address);

    const OvenueFactory = await ethers.getContractFactory("OvenueFactory");
    const factory = await upgrades.deployProxy(OvenueFactory, [
      owner.address,
      config.address,
    ]);

    const OvenueExchange = await ethers.getContractFactory("OvenueExchange");
    const exchange = await OvenueExchange.deploy();

    await config.setCreditLineImplementation(creditLine.address);
    await config.setTranchedPoolImplementation(juniorPool.address);
    await config.setBorrowerImplementation(borrowerImpl.address);
    await config.setSeniorPoolStrategy(fixedSeniorStrategy.address);
    await config.setOvenueConfig(config.address);
    await config.setTreasuryReserve(treasury.address);
    // set withdraw fee denominator
    await config.setNumber(4, 200);
    // set reserve fee denominator
    await config.setNumber(3, 10);
    // set Ovenue Senior LP
    await config.setAddress(2, seniorLP.address);
    // set junior pool LP  address
    await config.setAddress(8, juniorLP.address);
    // set Go address
    await config.setAddress(13, go.address);
    // set Senior pool
    await config.setAddress(9, seniorPool.address);
    // set Ovenue Factory
    await config.setAddress(1, factory.address);
    // set Protocol admin
    await config.setAddress(6, owner.address);
    // set Leverage ratio - 4X
    await config.setNumber(9, expandTo18Decimals(4, 18));
    // set Drawdown period in seconds - 5 days
    await config.setNumber(7, 200);
    // set lateness grace period in days
    await config.setNumber(5, 10);
    // set voting period - 30 blocks
    await config.setNumber(12, 30);
    // set Junior rewards
    await config.setAddress(14, juniorRewards.address);
    // set collateral token
    await config.setAddress(15, usdc.address);
    // set collateral governance impl
    await config.setAddress(17, governanceImpl.address);
    // set exchange address 
    await config.setAddress(18, exchange.address);

    await config.addToGoList(seniorPool.address);

    const CollateralCustody = await ethers.getContractFactory(
      "OvenueCollateralCustody",
      {
        libraries: {
          OvenueExchangeHelper: exchangeHelper.address,
          OvenueCollateralCustodyLogic: ovenueCollateralCustodyLogic.address,
        },
      }
    );
    const collateralCustody = await upgrades.deployProxy(
      CollateralCustody,
      [owner.address, config.address],
      {
        unsafeAllow: ["external-library-linking"],
      }
    );

    // Collateral custody
    await config.setAddress(16, collateralCustody.address);

    const SPV = await ethers.getContractFactory("SPV");
    const spv = await SPV.deploy();

    await spv.mint(borrower.address);

    await factory.connect(borrower).createBorrower(borrower.address);

    const borrowerAddress = ethers.utils.getContractAddress({
      from: factory.address,
      nonce: 1,
    });

    return {
      exchange,
      juniorPoolLogic,
      owner,
      borrower,
      borrowerSupport: await borrowerImpl.attach(borrowerAddress),
      treasury,
      fstInvestor,
      secInvestor,
      tidInvestor,
      config,
      factory,
      seniorPool,
      seniorLP,
      usdc,
      spv,
      JuniorPool,
      CreditLine,
      uniqueIdentity,
      juniorRewards,
      juniorLP,
      collateralCustody,
    };
  }

  describe("Lending/Borrow first scenario", async () => {
    async function deployLendingPool() {
      const {
        CreditLine,
        JuniorPool,
        collateralCustody,
        borrowerSupport,
        juniorLP,
        usdc,
        spv,
        uniqueIdentity,
        seniorLP,
        seniorPool,
        factory,
        config,
        borrower,
        owner,
        fstInvestor,
        secInvestor,
        tidInvestor,
      } = await loadFixture(deployAllLendingContracts);

      const poolAddress = ethers.utils.getContractAddress({
        from: factory.address,
        nonce: 2,
      });

      const governanceAddress = ethers.utils.getContractAddress({
        from: factory.address,
        nonce: 3,
      });

      await expect(
        factory.createPool(
          [config.address, borrowerSupport.address, spv.address],
          [20, expandTo18Decimals(10, 16), expandTo18Decimals(10, 16)],
          [
            paymentPeriodInDays,
            termInDays,
            principalGracePeriodInDays,
            fundableAt,
          ],
          expandTo18Decimals(500, 6), // USDC collateral
          expandTo18Decimals(10000, 6),
          "0", // token ID
          [0, 1, 2, 3]
        )
      )
        .to.be.emit(factory, "PoolCreated")
        .withArgs(poolAddress, governanceAddress, borrowerSupport.address);

      const juniorPool = await JuniorPool.attach(poolAddress);

      await usdc.initializeV2("USDC");
      await usdc.configureMinter(
        owner.address,
        expandTo18Decimals(1000000000000, 18)
      );

      await usdc.mint(fstInvestor.address, expandTo18Decimals(3000000000, 6));
      await usdc.mint(borrower.address, expandTo18Decimals(300000, 6));
      await usdc.mint(secInvestor.address, expandTo18Decimals(3000000, 6));

      await usdc
        .connect(fstInvestor)
        .approve(seniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(fstInvestor)
        .approve(seniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(fstInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(secInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));

      await usdc
        .connect(tidInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));

      await usdc
        .connect(borrower)
        .approve(collateralCustody.address, expandTo18Decimals(200000, 6));

      const juniorTrancheID = "2";
      const KYC_TYPE = 1; // Non-us
      const KYC_EXPIRED_AT =
        Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

      await spv
        .connect(borrower)
      ["safeTransferFrom(address,address,uint256,bytes)"](
        borrower.address,
        collateralCustody.address,
        "0",
        ethers.utils.defaultAbiCoder.encode(["address"], [juniorPool.address])
      );

      await borrowerSupport
        .connect(borrower)
        .lockCollateralToken(juniorPool.address, expandTo18Decimals(500, 6));

      const fstSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        fstInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(fstInvestor.address),
        // hardhat local blockchain id
        31337
      );

      const secSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        secInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(fstInvestor.address),
        // hardhat local blockchain id
        31337
      );

      const tidSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        tidInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(tidInvestor.address),
        // hardhat local blockchain id
        31337
      );

      await uniqueIdentity
        .connect(fstInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, fstSignature, {
          value: "830000000000000",
        });

      await uniqueIdentity
        .connect(secInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, secSignature, {
          value: "830000000000000",
        });

      await uniqueIdentity
        .connect(tidInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, tidSignature, {
          value: "830000000000000",
        });

      await time.setNextBlockTimestamp(fundableAt);

      await juniorPool
        .connect(fstInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(10000, 6));

      await juniorPool
        .connect(secInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(20000, 6));

      // await juniorPool
      //   .connect(secInvestor)
      //   .deposit(juniorTrancheID, expandTo18Decimals(20000, 6));

      await seniorPool
        .connect(fstInvestor)
        .deposit(expandTo18Decimals(200000, 6));

      return {
        CreditLine,
        JuniorPool,
        seniorLP,
        seniorPool,
        borrowerSupport,
        usdc,
        spv,
        factory,
        config,
        borrower,
        owner,
        juniorPool,
        juniorLP,
        uniqueIdentity,
        fstInvestor,
        secInvestor,
      };
    }

    xit("Non-Borrower not allows to drawdown other borrow pool", async () => {
      const { juniorPool, borrowerSupport, JuniorPool, fstInvestor } =
        await loadFixture(deployLendingPool);
      await expect(
        juniorPool.connect(fstInvestor).drawdown(expandTo18Decimals(500, 6))
      ).to.be.revertedWithCustomError(juniorPool, "UnauthorizedCaller");
    });

    xit("Borrower not allows to drawdown when junior principal not closed", async () => {
      const { juniorPool, borrowerSupport, borrower } = await loadFixture(
        deployLendingPool
      );
      await expect(
        borrowerSupport
          .connect(borrower)
          .drawdown(
            juniorPool.address,
            expandTo18Decimals(500, 6),
            borrower.address
          )
      ).to.be.revertedWith("NL");
    });

    xit("Borrower allows to drawdown when junior and senior pool is closed", async () => {
      const {
        CreditLine,
        seniorPool,
        borrowerSupport,
        juniorPool,
        usdc,
        borrower,
      } = await loadFixture(deployLendingPool);

      await borrowerSupport
        .connect(borrower)
        .lockJuniorCapital(juniorPool.address);
      // await borrowerSupport.connect(borrower).lockPool(juniorPool.address);

      await seniorPool.connect(borrower).invest(juniorPool.address);

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const borrowerBalance = await usdc.balanceOf(borrower.address);

      const startBorrowTime = fundableAt + 24 * 60 * 60;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(500, 6),
          borrower.address
        );

      const borrowerBalanceAfter = await usdc.balanceOf(borrower.address);

      expect(borrowerBalanceAfter).to.be.equals(
        borrowerBalance.add(expandTo18Decimals(500, 6))
      );

      const ownedBalance = await creditLine.balance();
      expect(ownedBalance).to.be.equals(expandTo18Decimals(500, 6));

      const lastFullPaymentTime = await creditLine.lastFullPaymentTime();
      const nextDueTime = await creditLine.nextDueTime();
      const currentLimit = await creditLine.limit();

      const trancheInfo = await juniorPool.getTranche("2");

      expect(trancheInfo.principalSharePrice).to.be.greaterThanOrEqual(
        `${expandTo18DecimalsRaw(1, 18)
          .mul(150000 - 500)
          .div(150000)}`
      );

      expect(currentLimit).to.be.equals(expandTo18Decimals(10000, 6));
      expect(nextDueTime).to.be.equals(
        startBorrowTime + paymentPeriodInDays * DAY_IN_SECONDS
      );
      expect(lastFullPaymentTime).to.be.equals(startBorrowTime);
    });

    xit("Borrower not allows to drawdown exceeds maximum limit even though funds is enough", async () => {
      const { CreditLine, borrowerSupport, juniorPool, usdc, borrower } =
        await loadFixture(deployLendingPool);

      await borrowerSupport
        .connect(borrower)
        .lockJuniorCapital(juniorPool.address);
      await borrowerSupport.connect(borrower).lockPool(juniorPool.address);

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const borrowerBalance = await usdc.balanceOf(borrower.address);

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await expect(
        borrowerSupport
          .connect(borrower)
          .drawdown(
            juniorPool.address,
            expandTo18Decimals(11000, 6),
            borrower.address
          )
      ).to.be.revertedWith("Cannot drawdown more than the limit");

      const borrowerBalanceAfter = await usdc.balanceOf(borrower.address);

      expect(borrowerBalanceAfter).to.be.equals(borrowerBalance);

      const ownedBalance = await creditLine.balance();
      expect(ownedBalance).to.be.equals(0);

      // const lastFullPaymentTime = await creditLine.lastFullPaymentTime();
      // const nextDueTime = await creditLine.share();
      const currentLimit = await creditLine.limit();

      expect(currentLimit).to.be.equals(expandTo18Decimals(10000, 6));
      // expect(nextDueTime).to.be.equals(startBorrowTime + paymentPeriodInDays * DAY_IN_SECONDS);
      // expect(lastFullPaymentTime).to.be.equals(startBorrowTime);
    });

    xit("Borrower not allows to drawdown after term end times", async () => {
      const { CreditLine, borrowerSupport, juniorPool, borrower } =
        await loadFixture(deployLendingPool);

      await borrowerSupport
        .connect(borrower)
        .lockJuniorCapital(juniorPool.address);
      await borrowerSupport.connect(borrower).lockPool(juniorPool.address);

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(500, 6),
          borrower.address
        );

      await time.setNextBlockTimestamp(startBorrowTime + 32 * DAY_IN_SECONDS);

      await expect(
        borrowerSupport
          .connect(borrower)
          .drawdown(
            juniorPool.address,
            expandTo18Decimals(500, 6),
            borrower.address
          )
      ).to.be.revertedWith("After termEndTime");

      const creditBalance = await creditLine.balance();
      expect(creditBalance).to.be.equals(expandTo18Decimals(500, 6));
    });

    xit("Interest will be accumulated for senior/junior per payment period", async () => {
      const { CreditLine, borrowerSupport, juniorPool, config, borrower } =
        await loadFixture(deployLendingPool);

      await juniorPool.lockJuniorCapital();
      await juniorPool.lockPool();

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(500, 6),
          borrower.address
        );

      await time.setNextBlockTimestamp(startBorrowTime + 2 * DAY_IN_SECONDS);

      await config.setNumber(5, 10);

      // set lateness period
      await juniorPool.assess();

      const nextDueTime = await creditLine.nextDueTime();
      const lastPaymentTime = await creditLine.lastFullPaymentTime();
      const totalInterestAccrued = await creditLine.totalInterestAccrued();

      expect(
        Math.floor(
          (((expandTo18Decimals(500, 6) * expandTo18Decimals(10, 16)) /
            expandTo18Decimals(1, 18)) *
            (2 * DAY_IN_SECONDS)) /
          (365 * DAY_IN_SECONDS)
        )
      ).to.be.equals(totalInterestAccrued);
      expect(lastPaymentTime).to.be.equals(startBorrowTime);
      expect(nextDueTime).to.be.equals(startBorrowTime + 3 * DAY_IN_SECONDS);
    });

    it("Tranched pool token redeem", async () => {
      const {
        seniorPool,
        fstInvestor,
        secInvestor,
        CreditLine,
        borrowerSupport,
        juniorLP,
        juniorPool,
        config,
        borrower,
        usdc,
      } = await loadFixture(deployLendingPool);

      await usdc
        .connect(fstInvestor)
        .approve(seniorPool.address, expandTo18Decimals(10000000, 6));
      await seniorPool
        .connect(fstInvestor)
        .deposit(expandTo18Decimals(10000000, 6));

      await juniorPool.lockJuniorCapital();
      await seniorPool.connect(fstInvestor).invest(juniorPool.address);
      // await juniorPool.lockPool();

      const startWithdrawTime = fundableAt + 6 * 24 * 60 * 60;

      await time.increaseTo(startWithdrawTime);

      const availableToWithdraw = await juniorPool.availableToWithdraw("1");

      await juniorPool
        .connect(fstInvestor)
        .withdraw("1", availableToWithdraw[0].add(availableToWithdraw[1]));

      // await juniorPool
      // .connect(secInvestor)
      // .withdraw("2", secAvailableToWithdraw[0].add(secAvailableToWithdraw[1]));

      // const tokenId = await juniorLP.getTokenInfo("1");

      const trancheInfo = await juniorPool.getTranche("2");
      console.log(trancheInfo);

      const usdcBalance = await usdc.balanceOf(juniorPool.address);
      console.log("Balance: ", usdcBalance);

      const startBorrowTime = startWithdrawTime + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(500, 6),
          borrower.address
        );

      await time.setNextBlockTimestamp(startBorrowTime + 2 * DAY_IN_SECONDS);

      await config.setNumber(5, 10);

      // // set lateness period
      // await juniorPool.assess();

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const nextDueTime = await creditLine.nextDueTime();
      const lastPaymentTime = await creditLine.lastFullPaymentTime();
      const totalInterestAccrued = await creditLine.totalInterestAccrued();

      const repay = Math.floor(
        (((expandTo18Decimals(500, 6) * expandTo18Decimals(10, 16)) /
          expandTo18Decimals(1, 18)) *
          (2 * DAY_IN_SECONDS)) /
        (365 * DAY_IN_SECONDS)
      );
      // expect(
      //   Math.floor(
      //     (((expandTo18Decimals(500, 6) * expandTo18Decimals(10, 16)) /
      //       expandTo18Decimals(1, 18)) *
      //       (2 * DAY_IN_SECONDS)) /
      //       (365 * DAY_IN_SECONDS)
      //   )
      // ).to.be.equals(totalInterestAccrued);
      // expect(lastPaymentTime).to.be.equals(startBorrowTime);
      // expect(nextDueTime).to.be.equals(startBorrowTime + 3 * DAY_IN_SECONDS);
      //

      // await juniorPool.connect(secInvestor).withdraw("2", expandTo18Decimals(2000, 6));
      console.log("LP: ====> ", await juniorLP.pools(juniorPool.address));
      await usdc
        .connect(borrower)
        .approve(borrowerSupport.address, expandTo18Decimals(100000));
      await borrowerSupport
        .connect(borrower)
        .pay(juniorPool.address, expandTo18DecimalsRaw(500, 6).add(repay));

      const balance = await creditLine.balance();
      console.log("BALANCE =>>>>> ", balance);

      // const secAvailableToWithdraw = await juniorPool.availableToWithdraw("2");
      const fstAvailableToWithdraw = await juniorPool.availableToWithdraw("1");
      // const tokenInfo = await juniorLP.getTokenInfo("1");
      // console.log(tokenInfo);
      console.log(fstAvailableToWithdraw);
      // console.log(await usdc.balanceOf(creditLine.address));
      const balanceBefore = await usdc.balanceOf(fstInvestor.address);
      await juniorPool
        .connect(fstInvestor)
        .withdraw("1", fstAvailableToWithdraw[0]);
      const balanceAfter = await usdc.balanceOf(fstInvestor.address);

      console.log(balanceBefore, balanceAfter);
    });

    it("Pool creation can has zero fungible collateral amount", async () => {
      const {
        CreditLine,
        JuniorPool,
        collateralCustody,
        borrowerSupport,
        juniorLP,
        usdc,
        spv,
        uniqueIdentity,
        seniorLP,
        seniorPool,
        factory,
        config,
        borrower,
        owner,
        fstInvestor,
        secInvestor,
        tidInvestor,
      } = await loadFixture(deployAllLendingContracts);

      await expect(
        factory.createPool(
          [config.address, borrowerSupport.address, spv.address],
          [20, expandTo18Decimals(10, 16), expandTo18Decimals(10, 16)],
          [
            paymentPeriodInDays,
            termInDays,
            principalGracePeriodInDays,
            fundableAt,
          ],
          expandTo18Decimals(0, 6), // USDC collateral
          expandTo18Decimals(10000, 6),
          "0", // token ID
          [0, 1, 2, 3]
        )
      ).to.be.emit(factory, "PoolCreated");

      const poolAddress = ethers.utils.getContractAddress({
        from: factory.address,
        nonce: 2,
      });

      const juniorPool = await JuniorPool.attach(poolAddress);

      console.log("OWNER: ", await spv.ownerOf("0"), borrower.address);
      await spv
        .connect(borrower)
      ["safeTransferFrom(address,address,uint256,bytes)"](
        borrower.address,
        collateralCustody.address,
        "0",
        ethers.utils.defaultAbiCoder.encode(["address"], [poolAddress])
      );

      const isFullyFunded = await collateralCustody.isCollateralFullyFunded(
        poolAddress
      );

      expect(isFullyFunded).to.be.equals(true);

      // Mint USDC for minter
      await usdc.initializeV2("USDC");
      await usdc.configureMinter(
        owner.address,
        expandTo18Decimals(1000000000000, 18)
      );
      await usdc.mint(fstInvestor.address, expandTo18Decimals(3000000000, 6));

      await usdc
        .connect(fstInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));

      const juniorTrancheID = "2";
      const KYC_TYPE = 1; // Non-us
      const KYC_EXPIRED_AT =
        Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

      const fstSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        fstInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(fstInvestor.address),
        // hardhat local blockchain id
        31337
      );

      await uniqueIdentity
        .connect(fstInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, fstSignature, {
          value: "830000000000000",
        });

      await time.setNextBlockTimestamp(fundableAt);

      await juniorPool
        .connect(fstInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(100, 5));

      await juniorPool.lockJuniorCapital();
      await juniorPool.lockPool();

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(50, 5),
          borrower.address
        );

      const totalLoan = await creditLine.balance();
      expect(totalLoan).to.be.equals(expandTo18Decimals(50, 5));
    });
  });

  describe("NFT Liquidation DAO", async () => {
    const deployLendingPool = async () => {
      const {
        exchange,
        CreditLine,
        JuniorPool,
        collateralCustody,
        borrowerSupport,
        juniorLP,
        usdc,
        spv,
        uniqueIdentity,
        seniorLP,
        seniorPool,
        factory,
        config,
        borrower,
        owner,
        fstInvestor,
        secInvestor,
        tidInvestor,
      } = await loadFixture(deployAllLendingContracts);

      const poolAddress = ethers.utils.getContractAddress({
        from: factory.address,
        nonce: 2,
      });

      const governanceAddress = ethers.utils.getContractAddress({
        from: factory.address,
        nonce: 3,
      });

      await expect(
        factory.createPool(
          [config.address, borrowerSupport.address, spv.address],
          [20, expandTo18Decimals(10, 16), expandTo18Decimals(10, 16)],
          [
            paymentPeriodInDays,
            termInDays,
            principalGracePeriodInDays,
            fundableAt,
          ],
          expandTo18Decimals(500, 6), // USDC collateral
          expandTo18Decimals(10000, 6),
          "0", // token ID
          [0, 1, 2, 3]
        )
      )
        .to.be.emit(factory, "PoolCreated")
        .withArgs(poolAddress, governanceAddress, borrowerSupport.address);

      const juniorPool = await JuniorPool.attach(poolAddress);

      await usdc.initializeV2("USDC");
      await usdc.configureMinter(
        owner.address,
        expandTo18Decimals(1000000000000, 18)
      );


      // needs for liquidation part
      await expect(
        seniorLP.connect(fstInvestor).delegate(fstInvestor.address)
      ).to.be.emit(seniorLP, "DelegateChanged");

      await expect(
        seniorLP.connect(secInvestor).delegate(secInvestor.address)
      ).to.be.emit(seniorLP, "DelegateChanged");

      await usdc.mint(fstInvestor.address, expandTo18Decimals(3000000000, 6));
      await usdc.mint(borrower.address, expandTo18Decimals(300000, 6));
      await usdc.mint(secInvestor.address, expandTo18Decimals(300000, 6));

      await usdc
        .connect(fstInvestor)
        .approve(seniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(secInvestor)
        .approve(seniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(fstInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));
      await usdc
        .connect(secInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));

      await usdc
        .connect(tidInvestor)
        .approve(juniorPool.address, expandTo18Decimals(200000, 6));

      await usdc
        .connect(borrower)
        .approve(collateralCustody.address, expandTo18Decimals(200000, 6));

      const juniorTrancheID = "2";
      const KYC_TYPE = 1; // Non-us
      const KYC_EXPIRED_AT =
        Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

      await spv
        .connect(borrower)
      ["safeTransferFrom(address,address,uint256,bytes)"](
        borrower.address,
        collateralCustody.address,
        "0",
        ethers.utils.defaultAbiCoder.encode(["address"], [juniorPool.address])
      );

      await borrowerSupport
        .connect(borrower)
        .lockCollateralToken(juniorPool.address, expandTo18Decimals(500, 6));

      const fstSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        fstInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(fstInvestor.address),
        // hardhat local blockchain id
        31337
      );

      const secSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        secInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(fstInvestor.address),
        // hardhat local blockchain id
        31337
      );

      const tidSignature = await buildUIDIssuanceSignature(
        owner,
        uniqueIdentity.address,
        tidInvestor.address,
        KYC_TYPE,
        KYC_EXPIRED_AT,
        await uniqueIdentity.nonces(tidInvestor.address),
        // hardhat local blockchain id
        31337
      );

      await uniqueIdentity
        .connect(fstInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, fstSignature, {
          value: "830000000000000",
        });

      await uniqueIdentity
        .connect(secInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, secSignature, {
          value: "830000000000000",
        });

      await uniqueIdentity
        .connect(tidInvestor)
        .mint(KYC_TYPE, KYC_EXPIRED_AT, tidSignature, {
          value: "830000000000000",
        });

      await time.setNextBlockTimestamp(fundableAt);

      await juniorPool
        .connect(fstInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(10000, 6));

      await juniorPool
        .connect(secInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(20000, 6));

      // await juniorPool
      //   .connect(secInvestor)
      //   .deposit(juniorTrancheID, expandTo18Decimals(20000, 6));

      await seniorPool
        .connect(fstInvestor)
        .deposit(expandTo18Decimals(200000, 6));

      await juniorPool
        .connect(fstInvestor)
        .deposit(juniorTrancheID, expandTo18Decimals(10000, 6));

      await juniorPool.lockJuniorCapital();
      await juniorPool.lockPool();

      const creditLine = await CreditLine.attach(await juniorPool.creditLine());

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;

      await time.setNextBlockTimestamp(startBorrowTime);

      await borrowerSupport
        .connect(borrower)
        .drawdown(
          juniorPool.address,
          expandTo18Decimals(1000, 6),
          borrower.address
        );

      const GovernanceLogic = await ethers.getContractFactory(
        "OvenueCollateralGovernanceLogic"
      );
      const governanceLogic = await GovernanceLogic.deploy();

      const Governance = await ethers.getContractFactory(
        "OvenueCollateralGovernance",
        {
          libraries: {
            OvenueCollateralGovernanceLogic: governanceLogic.address,
          },
        }
      );
      const governance = Governance.attach(governanceAddress);

      return {
        collateralCustody,
        exchange,
        governance,
        creditLine,
        JuniorPool,
        seniorLP,
        seniorPool,
        borrowerSupport,
        usdc,
        spv,
        factory,
        config,
        borrower,
        owner,
        juniorPool,
        juniorLP,
        uniqueIdentity,
        fstInvestor,
        secInvestor,
      };
    };
    it("Delegates themselves before voting (1 time transaction)", async () => {
      const {
        seniorLP,
        seniorPool,
        fstInvestor,
        secInvestor,
        borrowerSupport,
        juniorLP,
        juniorPool,
        config,
        borrower,
        usdc,
      } = await loadFixture(deployLendingPool);

      expect(await seniorLP.getVotes(fstInvestor.address)).to.be.equals(
        expandTo18Decimals(200000, 18)
      );
    });

    it("Senior LP token holders will trigger liquidation", async () => {
      const {
        creditLine,
        exchange,
        governance,
        seniorLP,
        seniorPool,
        fstInvestor,
        secInvestor,
        borrowerSupport,
        juniorLP,
        juniorPool,
        config,
        borrower,
        usdc,
        spv,
        collateralCustody,
      } = await loadFixture(deployLendingPool);

      const collateralCustodyIface = new ethers.utils.Interface(
        CollateralCustodyJSON
      );
      const erc721Iface = new ethers.utils.Interface(ERC721JSON);

      const callDataEncoded = erc721Iface.encodeFunctionData(
        "safeTransferFrom(address,address,uint256)",
        [collateralCustody.address, ethers.constants.AddressZero, "0"]
      );

      let listNFTToMarketplaceEncoded =
        collateralCustodyIface.encodeFunctionData("listNFTToMarketplace", [
          juniorPool.address,
          [
            exchange.address,
            ethers.constants.AddressZero,
            collateralCustody.address,
            fstInvestor.address,
            spv.address,
            ethers.constants.AddressZero,
          ],
          [
            250,
            250,
            expandTo18Decimals(1000, 6),
            Math.floor(Date.now() / 1000),
            Math.floor(Date.now() / 1000) + 30000,
            209, // salt purpose
          ],
          0,
          0,
          0,
          callDataEncoded,
          "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000",
          true,
        ]);

      await expect(
        governance.propose(
          [collateralCustody.address],
          [0],
          [listNFTToMarketplaceEncoded],
          "Transaction to liquidate NFT"
        )
      ).to.be.emit(governance, "ProposalCreated");

      // const proposalId = await governance.hashProposal(
      //   [collateralCustody.address],
      //   [0],
      //   [listNFTToMarketplaceEncoded],
      //   ethers.utils.keccak256(
      //     ethers.utils.toUtf8Bytes("Transaction to liquidate NFT")
      //   )
      // );
    });

    it("Senior LP token holders will trigger liquidation when condition is satisfied", async () => {
      const {
        creditLine,
        exchange,
        governance,
        seniorLP,
        seniorPool,
        fstInvestor,
        secInvestor,
        borrowerSupport,
        juniorLP,
        juniorPool,
        config,
        borrower,
        usdc,
        spv,
        collateralCustody,
      } = await loadFixture(deployLendingPool);
      const liquidationTime = fundableAt + 12 * 24 * 60 * 60;
      // 12 days
      await time.increaseTo(liquidationTime);

      const collateralCustodyIface = new ethers.utils.Interface(
        CollateralCustodyJSON
      );
      const erc721Iface = new ethers.utils.Interface(ERC721JSON);

      const callDataEncoded = erc721Iface.encodeFunctionData(
        "safeTransferFrom(address,address,uint256)",
        [collateralCustody.address, ethers.constants.AddressZero, "0"]
      );

      let listNFTToMarketplaceEncoded =
        collateralCustodyIface.encodeFunctionData("listNFTToMarketplace", [
          juniorPool.address,
          [
            exchange.address,
            collateralCustody.address,
            ethers.constants.AddressZero,
            fstInvestor.address,
            spv.address,
            usdc.address,
          ],
          [
            250,
            250,
            expandTo18Decimals(1000, 6),
            liquidationTime,
            liquidationTime + 30000,
            209, // salt purpose
          ],
          1,
          0,
          0,
          callDataEncoded,
          "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000",
          true,
        ]);

      const isLate = await creditLine.isLate();
      expect(isLate).to.be.equals(true);

      const eligibleForLiquidation =
        await collateralCustody.eligibleForLiquidation(juniorPool.address);

      expect(eligibleForLiquidation).to.be.equals(true);

      await expect(
        governance.propose(
          [collateralCustody.address],
          [0],
          [listNFTToMarketplaceEncoded],
          "Transaction to liquidate NFT"
        )
      ).to.be.emit(governance, "ProposalCreated");

      const proposalId = await governance.hashProposal(
        [collateralCustody.address],
        [0],
        [listNFTToMarketplaceEncoded],
        ethers.utils.keccak256(
          ethers.utils.toUtf8Bytes("Transaction to liquidate NFT")
        )
      );

      // Mine one block to make proposal state becomes "Active"
      await mine(1);

      console.log("State: ", await governance.state(proposalId));

      await governance.connect(fstInvestor).castVote(
        proposalId,
        1, // support => Against - 0, For - 1, Abstain - 2
      )

      await governance.connect(secInvestor).castVote(
        proposalId,
        1, // support => Against - 0, For - 1, Abstain - 2
      )

      const hasVoted = await governance.hasVoted(proposalId, fstInvestor.address);
      expect(hasVoted).to.be.equals(true);

      const proposalVotes = await governance.proposalVotes(proposalId);
      console.log("Proposal: ", proposalVotes);

      await mine(30);

      await expect(
        governance.execute(
          [collateralCustody.address],
          [0],
          [listNFTToMarketplaceEncoded],
          ethers.utils.keccak256(
            ethers.utils.toUtf8Bytes("Transaction to liquidate NFT")
          )
        )
      ).to.be.emit(governance, "ProposalExecuted").withArgs(proposalId);

      const liquidationOrder = await collateralCustody.poolNFTCollateralLiquidation(
        juniorPool.address
      );

      const buyCallDataEncoded = erc721Iface.encodeFunctionData(
        "safeTransferFrom(address,address,uint256)",
        [ethers.constants.AddressZero, secInvestor.address, "0"]
      );

      // approve exchange contract to use tokens
      await usdc.connect(secInvestor).approve(
        exchange.address,
        expandTo18Decimals(10000, 6)
      );

      await exchange.connect(secInvestor).atomicMatch_(
        [
          exchange.address,
          secInvestor.address,
          ethers.constants.AddressZero,
          ethers.constants.AddressZero,
          spv.address,
          usdc.address,
          exchange.address,
          collateralCustody.address,
          ethers.constants.AddressZero,
          fstInvestor.address,
          spv.address,
          usdc.address,
        ],
        [
          250,
          250,
          expandTo18Decimals(1000, 6),
          liquidationTime,
          liquidationTime + 30000,
          1000, // salt purpose
          250,
          250,
          expandTo18Decimals(1000, 6),
          liquidationTime,
          liquidationTime + 30000,
          209, // salt purpose
        ],
        [
          0,
          0,
          0,
          1,
          0,
          0,
        ],
        buyCallDataEncoded,
        callDataEncoded,
        "0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
        "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000",
        [
          28,
          28
        ],
        [
          ethers.constants.HashZero,
          ethers.constants.HashZero,
          ethers.constants.HashZero,
          ethers.constants.HashZero
        ]
      )

      // const trancheInfo = await juniorPool.getTranche("2");
      
      await collateralCustody.connect(fstInvestor).recoverLossFundsForInvestors(
        juniorPool.address,
        false
      );

      const startBorrowTime = fundableAt + DAY_IN_SECONDS;
      const assessTime = await time.latest();

      console.log(startBorrowTime, assessTime);

      const interest = expandTo18DecimalsRaw(1000, 6).mul(expandTo18Decimals(10, 16)).div(expandTo18Decimals(1, 18)).mul(assessTime - startBorrowTime).div(ONE_YEAR);

      console.log("Interest: ", interest);

      const trancheInfoAfter = await juniorPool.getTranche("2");
      console.log(trancheInfoAfter);
    });

    it("Senior LP token holders will cancel liquidation if needed", async () => {
      const {
        creditLine,
        exchange,
        governance,
        seniorLP,
        seniorPool,
        fstInvestor,
        secInvestor,
        borrowerSupport,
        juniorLP,
        juniorPool,
        config,
        borrower,
        usdc,
        spv,
        collateralCustody,
      } = await loadFixture(deployLendingPool);
      const liquidationTime = fundableAt + 12 * 24 * 60 * 60;
      // 12 days
      await time.increaseTo(liquidationTime);

      const collateralCustodyIface = new ethers.utils.Interface(
        CollateralCustodyJSON
      );
      const erc721Iface = new ethers.utils.Interface(ERC721JSON);

      const callDataEncoded = erc721Iface.encodeFunctionData(
        "safeTransferFrom(address,address,uint256)",
        [collateralCustody.address, ethers.constants.AddressZero, "0"]
      );

      let listNFTToMarketplaceEncoded =
        collateralCustodyIface.encodeFunctionData("listNFTToMarketplace", [
          juniorPool.address,
          [
            exchange.address,
            collateralCustody.address,
            ethers.constants.AddressZero,
            fstInvestor.address,
            spv.address,
            usdc.address,
          ],
          [
            250,
            250,
            expandTo18Decimals(1000, 6),
            liquidationTime,
            liquidationTime + 30000,
            209, // salt purpose
          ],
          1,
          0,
          0,
          callDataEncoded,
          "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000",
          true,
        ]);

      const isLate = await creditLine.isLate();
      expect(isLate).to.be.equals(true);

      const eligibleForLiquidation =
        await collateralCustody.eligibleForLiquidation(juniorPool.address);

      expect(eligibleForLiquidation).to.be.equals(true);

      await expect(
        governance.propose(
          [collateralCustody.address],
          [0],
          [listNFTToMarketplaceEncoded],
          "Transaction to liquidate NFT"
        )
      ).to.be.emit(governance, "ProposalCreated");

      const proposalId = await governance.hashProposal(
        [collateralCustody.address],
        [0],
        [listNFTToMarketplaceEncoded],
        ethers.utils.keccak256(
          ethers.utils.toUtf8Bytes("Transaction to liquidate NFT")
        )
      );

      // Mine one block to make proposal state becomes "Active"
      await mine(1);

      console.log("State: ", await governance.state(proposalId));

      await governance.connect(fstInvestor).castVote(
        proposalId,
        1, // support => Against - 0, For - 1, Abstain - 2
      )

      await governance.connect(secInvestor).castVote(
        proposalId,
        1, // support => Against - 0, For - 1, Abstain - 2
      )

      const hasVoted = await governance.hasVoted(proposalId, fstInvestor.address);
      expect(hasVoted).to.be.equals(true);

      const proposalVotes = await governance.proposalVotes(proposalId);
      console.log("Proposal: ", proposalVotes);

      await mine(30);

      await expect(
        governance.execute(
          [collateralCustody.address],
          [0],
          [listNFTToMarketplaceEncoded],
          ethers.utils.keccak256(
            ethers.utils.toUtf8Bytes("Transaction to liquidate NFT")
          )
        )
      ).to.be.emit(governance, "ProposalExecuted").withArgs(proposalId);

      let cancelListingNFTToMarketplaceEncoded =
        collateralCustodyIface.encodeFunctionData("cancelListingNFTMarketplace", [
          juniorPool.address,
          [
            exchange.address,
            collateralCustody.address,
            ethers.constants.AddressZero,
            fstInvestor.address,
            spv.address,
            usdc.address,
          ],
          [
            250,
            250,
            expandTo18Decimals(1000, 6),
            liquidationTime,
            liquidationTime + 30000,
            209, // salt purpose
          ],
          1,
          0,
          0,
          callDataEncoded,
          "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000",
          true,
        ]);

      await expect(
        governance.propose(
          [collateralCustody.address],
          [0],
          [cancelListingNFTToMarketplaceEncoded],
          "Transaction to cancel liquidate NFT"
        )
      ).to.be.emit(governance, "ProposalCreated");

      const cancelProposalId = await governance.hashProposal(
        [collateralCustody.address],
        [0],
        [cancelListingNFTToMarketplaceEncoded],
        ethers.utils.keccak256(
          ethers.utils.toUtf8Bytes("Transaction to cancel liquidate NFT")
        )
      );

      //  // Mine one block to make proposal state becomes "Active"
      //  await mine(1);

      // await governance.connect(fstInvestor).castVote(
      //   cancelProposalId,
      //   1, // support => Against - 0, For - 1, Abstain - 2
      // )

      // await governance.connect(secInvestor).castVote(
      //   cancelProposalId,
      //   1, // support => Against - 0, For - 1, Abstain - 2
      // )

      // await mine(30);

      // await expect(
      //   governance.execute(
      //     [collateralCustody.address],
      //     [0],
      //     [cancelListingNFTToMarketplaceEncoded],
      //     ethers.utils.keccak256(
      //       ethers.utils.toUtf8Bytes("Transaction to cancel liquidate NFT")
      //     )
      //   )
      // ).to.be.emit(governance, "ProposalExecuted").withArgs(proposalId);

    });
  });
});