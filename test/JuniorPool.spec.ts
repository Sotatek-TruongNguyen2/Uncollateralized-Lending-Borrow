import { expect } from "chai";
import { ethers, upgrades } from "hardhat";
import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expandTo18Decimals, expandTo18DecimalsRaw } from "./utils/utilities";
import { buildUIDIssuanceSignature } from "../scripts/UID";
import { buildDepositSignature } from "../scripts/depositWithPermit";

const paymentPeriodInDays = 24 * 60 * 60;
const termInDays = 30 * 24 * 60 * 60;
const principalGracePeriodInDays = paymentPeriodInDays / 2;
const fundableAt = Math.floor(new Date().getTime() / 1000) + 1 * 24 * 60 * 60;

describe("Lending", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployAllLendingContracts() {
        const [owner, treasury, borrower, fstInvestor, secInvestor] = await ethers.getSigners();

        // ============ Libraries =============== / 
        const TranchingLogic = await ethers.getContractFactory("OvenueTranchingLogic");
        const tranchingLogic = await TranchingLogic.deploy();

        const Accountant = await ethers.getContractFactory("Accountant");
        const accountant = await Accountant.deploy();

        // ============ Logic & Implementation =============== / 

        const JuniorPoolLogic = await ethers.getContractFactory("OvenueJuniorPoolLogic", {
            libraries: {
                "OvenueTranchingLogic": tranchingLogic.address,
            }
        });
        const juniorPoolLogic = await JuniorPoolLogic.deploy();

        const JuniorPool = await ethers.getContractFactory("OvenueJuniorPoolNoneKYC", {
            libraries: {
                "OvenueTranchingLogic": tranchingLogic.address,
                "OvenueJuniorPoolLogic": juniorPoolLogic.address
            }
        });
        const juniorPool = await JuniorPool.deploy();

        // ============ Main contract ================

        const CreditLine = await ethers.getContractFactory("CreditLine", {
            libraries: {
                Accountant: accountant.address
            }
        });
        const creditLine = await CreditLine.deploy();

        const BorrowerImpl = await ethers.getContractFactory("OvenueBorrower");
        const borrowerImpl = await BorrowerImpl.deploy();

        const Config = await ethers.getContractFactory("OvenueConfig");
        const config = await upgrades.deployProxy(Config, [owner.address]);

        const FixedSeniorStrategy = await ethers.getContractFactory("FixedLeverageRatioStrategy");
        const fixedSeniorStrategy = await upgrades.deployProxy(
            FixedSeniorStrategy,
            [owner.address, config.address]
        );


        const USDC = await ethers.getContractFactory("FiatTokenV2");
        const usdc = await upgrades.deployProxy(
            USDC,
            [
                "USD Coin",
                "USDC",
                "USDC",
                6,
                owner.address,
                owner.address,
                owner.address,
                owner.address
            ]
        );

        // USDC index
        await config.setAddress(3, usdc.address);

        const JuniorRewards = await ethers.getContractFactory("OvenueJuniorRewards");
        const juniorRewards = await upgrades.deployProxy(
            JuniorRewards,
            [owner.address, config.address],
        );

        const JuniorLP = await ethers.getContractFactory("OvenueJuniorLP");
        const juniorLP = await upgrades.deployProxy(
            JuniorLP,
            [owner.address, config.address],
        );

        const SeniorPool = await ethers.getContractFactory("OvenueSeniorPoolNoneKYC", {
            libraries: {
                Accountant: accountant.address
            }
        });
        const seniorPool = await upgrades.deployProxy(
            SeniorPool,
            [owner.address, config.address],
            {
                unsafeAllow: [
                    "external-library-linking"
                ]
            }
        );

        const UniqueIdentity = await ethers.getContractFactory("UniqueIdentity");
        const uniqueIdentity = await upgrades.deployProxy(
            UniqueIdentity,
            [owner.address, "https://unique.identity"],
        );

        await uniqueIdentity.setSupportedUIDTypes(
            [1, 2, 3, 4],
            [true, true, true, true]
        );

        const Go = await ethers.getContractFactory("Go");
        const go = await upgrades.deployProxy(
            Go,
            [
                owner.address,
                config.address,
                uniqueIdentity.address
            ]
        );

        const SeniorLP = await ethers.getContractFactory("OvenueSeniorLP");
        const seniorLP = await upgrades.deployProxy(
            SeniorLP,
            [
                owner.address,
                "Ovenue Senior LP",
                "OSL",
                config.address
            ],
            {
                initializer: "__initialize__"
            }
        );

        const OvenueFactory = await ethers.getContractFactory("OvenueFactory");
        const factory = await upgrades.deployProxy(
            OvenueFactory,
            [owner.address, config.address]
        );

        const CollateralCustody = await ethers.getContractFactory("OvenueCollateralCustody");
        const collateralCustody = await upgrades.deployProxy(CollateralCustody, [owner.address, config.address]);

        await config.setCreditLineImplementation(creditLine.address);
        await config.setTranchedPoolImplementation(juniorPool.address);
        await config.setBorrowerImplementation(borrowerImpl.address);
        await config.setSeniorPoolStrategy(fixedSeniorStrategy.address);
        await config.setOvenueConfig(config.address);
        await config.setTreasuryReserve(treasury.address);
        
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
        // set Drawdown period in seconds - 5 days
        await config.setNumber(7, 5 * 24 * 60 * 60);
        // set Junior rewards
        await config.setAddress(14, juniorRewards.address);
        // Collateral custody
        await config.setAddress(16, collateralCustody.address);
        // set collateral token
        await config.setAddress(15, usdc.address);

        const SPV = await ethers.getContractFactory("SPV");
        const spv = await SPV.deploy();

        await spv.mint(
            borrower.address
        );

        await factory.connect(borrower).createBorrower(borrower.address);

        const borrowerAddress = ethers.utils.getContractAddress({
            from: factory.address,
            nonce: 1
        });

        return {
            juniorPoolLogic,
            owner,
            borrower,
            borrowerSupport: await borrowerImpl.attach(borrowerAddress),
            treasury,
            fstInvestor,
            secInvestor,
            config,
            factory,
            seniorPool,
            seniorLP,
            usdc,
            spv,
            JuniorPool,
            uniqueIdentity,
            juniorRewards,
            juniorLP,
            collateralCustody
        }
    }

    describe("Deployment", async () => {
        it("Deployment should be successful!", async function () {
            const { juniorLP, seniorPool, factory, config } = await loadFixture(deployAllLendingContracts);
            expect(seniorPool.address).not.to.be.equals(ethers.constants.AddressZero);
            expect(factory.address).not.to.be.equals(ethers.constants.AddressZero);
            expect(config.address).not.to.be.equals(ethers.constants.AddressZero);
            expect(juniorLP.address).not.to.be.equals(ethers.constants.AddressZero);
        });
    })

    xdescribe("Pool creating", async () => {
        it("Admin ables to create a borrow pool", async () => {
            const { JuniorPool, borrowerSupport, spv, factory, config, borrower, owner } = await loadFixture(deployAllLendingContracts);

            const poolAddress = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: 2
            });

            await expect(
                factory.createPool(
                    [
                        config.address,
                        borrowerSupport.address,
                        spv.address
                    ],
                    [
                        20,
                        expandTo18Decimals(10, 16),
                        expandTo18Decimals(10, 16)
                    ],
                    [
                        paymentPeriodInDays,
                        termInDays,
                        principalGracePeriodInDays,
                        fundableAt
                    ],
                    expandTo18Decimals(500, 6), // USDC collateral
                    expandTo18Decimals(10000, 6), // limit
                    "1", // token ID 
                    [1, 2, 3]
                )
            ).to.be.emit(factory, "PoolCreated").withArgs(poolAddress, borrowerSupport.address);

            const juniorPool = await JuniorPool.attach(poolAddress);

            const allowedIDs = await juniorPool.getAllowedUIDTypes();
            const creditLine = await juniorPool.creditLine();
            const numSlices = await juniorPool.numSlices();

            expect(allowedIDs).to.be.deep.equals([1, 2, 3]);
            expect(numSlices).to.be.equals(1);
            expect(creditLine).not.to.be.equals(ethers.constants.AddressZero);

            const isLocker = await juniorPool.hasRole(
                await juniorPool.LOCKER_ROLE(),
                borrower.address
            );
            const isOwner = await juniorPool.hasRole(
                await juniorPool.OWNER_ROLE(),
                owner.address
            );
            expect(isOwner).to.be.equals(true);
        })

        it("Non-Admin not ables to create a borrow pool", async () => {
            const { JuniorPool, borrowerSupport, spv, factory, config, borrower, fstInvestor } = await loadFixture(deployAllLendingContracts);

            await expect(
                factory.connect(fstInvestor).createPool(
                    [
                        config.address,
                        borrowerSupport.address,
                        spv.address
                    ],
                    [
                        20,
                        expandTo18Decimals(10, 16),
                        expandTo18Decimals(10, 16)
                    ],
                    [
                        paymentPeriodInDays,
                        termInDays,
                        principalGracePeriodInDays,
                        fundableAt
                    ],
                    expandTo18Decimals(500, 6), // USDC collateral
                    expandTo18Decimals(10000, 6),
                    "1", // token ID 
                    [1, 2, 3]
                )
            ).to.be.revertedWith("Must have admin or borrower role to perform this action")
        });
    })

    xdescribe("Junior Pool Cancelling", async () => {
        async function deployLendingPool() {
            const { JuniorPool, borrowerSupport, juniorLP, usdc, spv, collateralCustody, uniqueIdentity, factory, config, borrower, owner, fstInvestor, secInvestor } = await loadFixture(deployAllLendingContracts);

            const poolAddress = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: 2
            });

            await expect(
                factory.createPool(
                    [
                        config.address,
                        borrowerSupport.address,
                        spv.address
                    ],
                    [
                        20,
                        expandTo18Decimals(10, 16),
                        expandTo18Decimals(10, 16)
                    ],
                    [
                        paymentPeriodInDays,
                        termInDays,
                        principalGracePeriodInDays,
                        fundableAt
                    ],
                    expandTo18Decimals(500, 6), // USDC collateral
                    expandTo18Decimals(10000, 6),
                    "0", // token ID 
                    [1, 2, 3]
                )
            ).to.be.emit(factory, "PoolCreated").withArgs(poolAddress, borrowerSupport.address);

            const juniorPool = await JuniorPool.attach(poolAddress);

            await usdc.initializeV2("USDC");
            await usdc.configureMinter(owner.address, expandTo18Decimals(1000000000000, 18));

            await usdc.mint(fstInvestor.address, expandTo18Decimals(10000, 6));
            await usdc.mint(borrower.address, expandTo18Decimals(10000, 6));
            await usdc.mint(secInvestor.address, expandTo18Decimals(10000, 6));

            await usdc.connect(fstInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));
            await usdc.connect(secInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));

            await usdc.connect(borrower).approve(collateralCustody.address, expandTo18Decimals(100000, 6));

            const juniorTrancheID = "2";
            const KYC_TYPE = 1; // Non-us
            const KYC_EXPIRED_AT = Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

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

            await uniqueIdentity.connect(fstInvestor).mint(
                KYC_TYPE,
                KYC_EXPIRED_AT,
                fstSignature,
                {
                    value: "830000000000000"
                }
            )

            await time.setNextBlockTimestamp(fundableAt);

            await juniorPool.connect(fstInvestor).deposit(
                juniorTrancheID,
                expandTo18Decimals(10000, 6)
            );

            await borrowerSupport.connect(borrower).lockJuniorCapital(juniorPool.address);

            return {
                JuniorPool, borrowerSupport, collateralCustody, usdc, spv, factory, config, borrower, owner, juniorPool, juniorLP, uniqueIdentity, fstInvestor, secInvestor
            }
        }

        it("Borrower allows to cancel borrow pool", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);
            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.emit(juniorPool, "PoolCancelled");

            await expect(
                await juniorPool.cancelled()
            ).to.be.equals(true);
        })

        it("Borrower able to claim collateral right away after cancelling borrow pool", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);
            
            const balanceBefore = await usdc.balanceOf(borrower.address);
            
            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.emit(juniorPool, "PoolCancelled");

            const spvOwner = await spv.ownerOf("0");
            const balanceAfter = await usdc.balanceOf(borrower.address);
            const collateralStatus = await collateralCustody.poolCollateralStatus(juniorPool.address);

            console.log(balanceBefore.toString(), balanceAfter.toString(), collateralStatus.fundedFungibleAmount.toString());

            expect(spvOwner).to.be.equals(borrower.address);
            expect(balanceAfter).to.be.equals(balanceBefore.add(expandTo18DecimalsRaw(500, 6)))
        })

        it("Borrower not allows to cancel borrow pool again", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);
            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.emit(juniorPool, "PoolCancelled");

            await expect(
                juniorPool.cancel()
            ).to.be.revertedWithCustomError(juniorPool, "PoolAlreadyCancelled");
        })

        it("Borrower not allows to cancel borrow pool after drawdown", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);

            await borrowerSupport.connect(borrower).drawdown(
                juniorPool.address,
                expandTo18Decimals(500, 6),
                borrower.address
            );

            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.revertedWithCustomError(juniorPool, "PoolNotPure");
        })

        it("Borrower not allows to drawdown after cancelling borrow pool", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);
            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.emit(juniorPool, "PoolCancelled");

            await expect(
                borrowerSupport.connect(borrower).drawdown(
                    juniorPool.address,
                    expandTo18Decimals(500, 6),
                    borrower.address
                )
            ).to.be.revertedWithCustomError(juniorPool, "PoolAlreadyCancelled");
        })

        it("Investor not allows to invest after cancelling borrow pool", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower, borrowerSupport } = await loadFixture(deployLendingPool);
            await expect(
                borrowerSupport.connect(borrower).cancel(juniorPool.address, borrower.address)
            ).to.be.emit(juniorPool, "PoolCancelled");

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    "2", // junior tranche ID
                    expandTo18Decimals(10000, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "PoolAlreadyCancelled");
        })
    });

    xdescribe("Junior Pool Funding", async () => {
        async function deployLendingPool() {
            const { JuniorPool, borrowerSupport, juniorLP, usdc, spv, collateralCustody, uniqueIdentity, factory, config, borrower, owner, fstInvestor, secInvestor } = await loadFixture(deployAllLendingContracts);

            const poolAddress = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: 2
            });

            await expect(
                factory.createPool(
                    [
                        config.address,
                        borrowerSupport.address,
                        spv.address
                    ],
                    [
                        20,
                        expandTo18Decimals(10, 16),
                        expandTo18Decimals(10, 16)
                    ],
                    [
                        paymentPeriodInDays,
                        termInDays,
                        principalGracePeriodInDays,
                        fundableAt
                    ],
                    expandTo18Decimals(500, 6), // USDC collateral
                    expandTo18Decimals(10000, 6),
                    "0", // token ID 
                    [1, 2, 3]
                )
            ).to.be.emit(factory, "PoolCreated").withArgs(poolAddress, borrowerSupport.address);

            const juniorPool = await JuniorPool.attach(poolAddress);

            await usdc.initializeV2("USDC");
            await usdc.configureMinter(owner.address, expandTo18Decimals(1000000000000, 18));

            await usdc.mint(fstInvestor.address, expandTo18Decimals(10000, 6));
            await usdc.mint(borrower.address, expandTo18Decimals(10000, 6));
            await usdc.mint(secInvestor.address, expandTo18Decimals(10000, 6));

            await usdc.connect(fstInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));
            await usdc.connect(secInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));

            await usdc.connect(borrower).approve(collateralCustody.address, expandTo18Decimals(100000, 6));
            return {
                JuniorPool, borrowerSupport, collateralCustody, usdc, spv, factory, config, borrower, owner, juniorPool, juniorLP, uniqueIdentity, fstInvestor, secInvestor
            }
        }

        it("Investors not allow to invest when pool not opens yet", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower } = await loadFixture(deployLendingPool);

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );


            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            const collateralLocked = await collateralCustody.isCollateralFullyFunded(juniorPool.address);
            expect(collateralLocked).to.be.equals(true);

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    "2",
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "PoolNotOpened");
        });

        it("Investors not allow to invest when NFT collateral not locked", async () => {
            const { JuniorPool, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower } = await loadFixture(deployLendingPool);

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    "2",
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "NotFullyCollateral");

            const collateralLocked = await collateralCustody.isCollateralFullyFunded(juniorPool.address);
            expect(collateralLocked).to.be.equals(false);
        });

        it("Investors not allow to invest when pool is locked", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower } = await loadFixture(deployLendingPool);

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            await juniorPool.lockJuniorCapital();

            const juniorTrancheID = "2";

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    juniorTrancheID,
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "JuniorTranchAlreadyLocked");

            const trancheInfo = await juniorPool.getTranche(juniorTrancheID);

            // Minus one due to new block is mined
            expect(trancheInfo.lockedUntil).to.be.equals(
                (await time.latest()) + 5 * 24 * 60 * 60 - 1
            );
        });

        xit("Investors not allows to invest when their KYC process not finished", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, spv, juniorPool, usdc, secInvestor, fstInvestor, borrower } = await loadFixture(deployLendingPool);

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            await time.setNextBlockTimestamp(fundableAt);

            const juniorTrancheID = "2";

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    juniorTrancheID,
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "AllowedUIDNotGranted").withArgs(
                fstInvestor.address
            );
        });

        xit("Normal Investors not allows to invest in senior tranche", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, uniqueIdentity, spv, juniorPool, usdc, secInvestor, fstInvestor, owner, borrower } = await loadFixture(deployLendingPool);

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            // const KYC_EXPIRED_AT =  await time.latest() + 2 * 24 * 60 * 60; // expired after 2 days
            const juniorTrancheID = "2";
            // const KYC_TYPE = 1; // Non-us

            await time.setNextBlockTimestamp(fundableAt);

            await expect(
                juniorPool.connect(fstInvestor).deposit(
                    juniorTrancheID,
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "AllowedUIDNotGranted").withArgs(
                fstInvestor.address
            );
        });

        it("Investors allow to invest after a certain amount of time", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, juniorLP, uniqueIdentity, juniorPool, usdc, spv, borrower, owner, secInvestor, fstInvestor } = await loadFixture(deployLendingPool);

            const juniorTrancheID = "2";
            const KYC_TYPE = 1; // Non-us
            const KYC_EXPIRED_AT = Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days


            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            const signature = await buildUIDIssuanceSignature(
                owner,
                uniqueIdentity.address,
                fstInvestor.address,
                KYC_TYPE,
                KYC_EXPIRED_AT,
                await uniqueIdentity.nonces(fstInvestor.address),
                // hardhat local blockchain id
                31337
            );

            await expect(
                uniqueIdentity.connect(fstInvestor).mint(
                    KYC_TYPE,
                    KYC_EXPIRED_AT,
                    signature,
                    {
                        value: "830000000000000"
                    }
                )
            ).to.be.emit(uniqueIdentity, "TransferSingle");

            expect(JuniorPool).not.to.be.equals(ethers.constants.AddressZero);

            const fstInvestorBalance = await usdc.balanceOf(fstInvestor.address);
            expect(fstInvestorBalance).to.be.equals(expandTo18Decimals(10000, 6));

            await time.setNextBlockTimestamp(fundableAt);

            await juniorPool.connect(fstInvestor).deposit(
                juniorTrancheID,
                expandTo18Decimals(1000, 6)
            );

            const tokenInfo = await juniorLP.getTokenInfo("1");
            console.log(tokenInfo);

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalAmount).to.be.equals(expandTo18Decimals(1000, 6));
        });

        it("Investors allow to invest with approve tx (EIP-2612 PERMIT)", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, juniorLP, uniqueIdentity, juniorPool, usdc, spv, borrower, owner, secInvestor, fstInvestor } = await loadFixture(deployLendingPool);

            const juniorTrancheID = "2";
            const KYC_TYPE = 1; // Non-us
            const KYC_EXPIRED_AT = Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            const signature = await buildUIDIssuanceSignature(
                owner,
                uniqueIdentity.address,
                fstInvestor.address,
                KYC_TYPE,
                KYC_EXPIRED_AT,
                await uniqueIdentity.nonces(fstInvestor.address),
                // hardhat local blockchain id
                31337
            );

            await expect(
                uniqueIdentity.connect(fstInvestor).mint(
                    KYC_TYPE,
                    KYC_EXPIRED_AT,
                    signature,
                    {
                        value: "830000000000000"
                    }
                )
            ).to.be.emit(uniqueIdentity, "TransferSingle");

            expect(JuniorPool).not.to.be.equals(ethers.constants.AddressZero);

            const fstInvestorBalance = await usdc.balanceOf(fstInvestor.address);
            expect(fstInvestorBalance).to.be.equals(expandTo18Decimals(10000, 6));

            // 30000s seconds from fundalbeAt moment
            const depositPermitExpires = `${fundableAt + 30000}`;

            const depositSig = await buildDepositSignature(
                fstInvestor,
                usdc.address,
                juniorPool.address,
                expandTo18Decimals(1000, 6),
                depositPermitExpires,
                "0"
            );

            await time.setNextBlockTimestamp(fundableAt);

            await juniorPool.connect(fstInvestor).depositWithPermit(
                juniorTrancheID,
                expandTo18Decimals(1000, 6),
                depositPermitExpires,
                depositSig.v,
                depositSig.r,
                depositSig.s
            );

            const tokenInfo = await juniorLP.getTokenInfo("1");

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalAmount).to.be.equals(expandTo18Decimals(1000, 6));
        });

        it("Investors  not allow to invest using wrong signature (EIP-2612 PERMIT)", async () => {
            const { JuniorPool, borrowerSupport, collateralCustody, juniorLP, uniqueIdentity, juniorPool, usdc, spv, borrower, owner, secInvestor, fstInvestor } = await loadFixture(deployLendingPool);

            const juniorTrancheID = "2";
            const KYC_TYPE = 1; // Non-us
            const KYC_EXPIRED_AT = Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );

            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

            const signature = await buildUIDIssuanceSignature(
                owner,
                uniqueIdentity.address,
                fstInvestor.address,
                KYC_TYPE,
                KYC_EXPIRED_AT,
                await uniqueIdentity.nonces(fstInvestor.address),
                // hardhat local blockchain id
                31337
            );

            await expect(
                uniqueIdentity.connect(fstInvestor).mint(
                    KYC_TYPE,
                    KYC_EXPIRED_AT,
                    signature,
                    {
                        value: "830000000000000"
                    }
                )
            ).to.be.emit(uniqueIdentity, "TransferSingle");

            expect(JuniorPool).not.to.be.equals(ethers.constants.AddressZero);

            const fstInvestorBalance = await usdc.balanceOf(fstInvestor.address);
            expect(fstInvestorBalance).to.be.equals(expandTo18Decimals(10000, 6));

            // 30000s seconds from fundalbeAt moment
            const depositPermitExpires = `${fundableAt + 30000}`;

            const depositSig = await buildDepositSignature(
                fstInvestor,
                usdc.address,
                juniorPool.address,
                expandTo18Decimals(1000, 6),
                depositPermitExpires,
                "0"
            );

            await time.setNextBlockTimestamp(fundableAt);

            await expect(juniorPool.connect(fstInvestor).depositWithPermit(
                juniorTrancheID,
                expandTo18Decimals(10000, 6),
                depositPermitExpires,
                depositSig.v,
                depositSig.r,
                depositSig.s
            )).to.be.revertedWith("EIP2612: invalid signature");
        });
    });

    xdescribe("Junior Pool Withdraw", async () => {
        async function deployLendingPool() {
            const { JuniorPool, borrowerSupport, collateralCustody, juniorLP, usdc, spv, uniqueIdentity, factory, config, borrower, owner, fstInvestor, secInvestor } = await loadFixture(deployAllLendingContracts);

            const poolAddress = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: 2
            });

            await expect(
                factory.createPool(
                    [
                        config.address,
                        borrowerSupport.address,
                        spv.address
                    ],
                    [
                        20,
                        expandTo18Decimals(10, 16),
                        expandTo18Decimals(10, 16)
                    ],
                    [
                        paymentPeriodInDays,
                        termInDays,
                        principalGracePeriodInDays,
                        fundableAt
                    ],
                    expandTo18Decimals(500, 6), // USDC collateral
                    expandTo18Decimals(10000, 6), // limit
                    "0", // token ID 
                    [1, 2, 3]
                )
            ).to.be.emit(factory, "PoolCreated").withArgs(poolAddress, borrowerSupport.address);

            const juniorPool = await JuniorPool.attach(poolAddress);

            await usdc.initializeV2("USDC");
            await usdc.configureMinter(owner.address, expandTo18Decimals(1000000000000, 18));

            await usdc.mint(fstInvestor.address, expandTo18Decimals(10000, 6));
            await usdc.mint(borrower.address, expandTo18Decimals(10000, 6));
            await usdc.mint(secInvestor.address, expandTo18Decimals(10000, 6));

            await usdc.connect(fstInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));
            await usdc.connect(secInvestor).approve(juniorPool.address, expandTo18Decimals(10000, 6));
            await usdc.connect(borrower).approve(collateralCustody.address, expandTo18Decimals(10000, 6));

            const juniorTrancheID = "2";
            const KYC_TYPE = 1; // Non-us
            const KYC_EXPIRED_AT = Math.floor(new Date().getTime() / 1000) + 10 * 24 * 60 * 60; // expired after 10 days

            await spv.connect(borrower)["safeTransferFrom(address,address,uint256,bytes)"](
                borrower.address,
                collateralCustody.address,
                "0",
                ethers.utils.defaultAbiCoder.encode(
                    ["address"],
                    [juniorPool.address]
                )
            );


            await borrowerSupport.connect(borrower).lockCollateralToken(
                juniorPool.address,
                expandTo18Decimals(500, 6)
            );

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

            await uniqueIdentity.connect(fstInvestor).mint(
                KYC_TYPE,
                KYC_EXPIRED_AT,
                fstSignature,
                {
                    value: "830000000000000"
                }
            )

            await uniqueIdentity.connect(secInvestor).mint(
                KYC_TYPE,
                KYC_EXPIRED_AT,
                secSignature,
                {
                    value: "830000000000000"
                }
            )

            await time.setNextBlockTimestamp(fundableAt);

            await juniorPool.connect(fstInvestor).deposit(
                juniorTrancheID,
                expandTo18Decimals(1000, 6)
            );

            await juniorPool.connect(secInvestor).deposit(
                juniorTrancheID,
                expandTo18Decimals(1000, 6)
            );

            return {
                borrowerSupport,
                JuniorPool, usdc, spv, factory, config, borrower, owner, juniorPool, juniorLP, uniqueIdentity, fstInvestor, secInvestor
            }
        }

        it("Investor allow to withdraw When junior capital not closed", async () => {
            const { juniorPool, juniorLP, usdc, fstInvestor, secInvestor } = await loadFixture(deployLendingPool);

            const balanceBefore = await usdc.balanceOf(fstInvestor.address);

            await juniorPool.connect(fstInvestor).withdraw(
                "1",
                expandTo18Decimals(1000, 6)
            );

            await juniorPool.connect(secInvestor).withdraw(
                "2",
                expandTo18Decimals(1000, 6)
            );

            const balanceAfter = await usdc.balanceOf(fstInvestor.address);

            const tokenInfo = await juniorLP.getTokenInfo("1");
            const secTokenInfo = await juniorLP.getTokenInfo("1");

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalRedeemed).to.be.equals(0);
            expect(tokenInfo.principalAmount).to.be.equals(0);

            expect(secTokenInfo.principalRedeemed).to.be.equals(0);
            expect(secTokenInfo.principalAmount).to.be.equals(0);

            expect(balanceAfter).to.be.equals(balanceBefore.add(expandTo18Decimals(1000, 6)));
        })

        it("Investor not allow to withdraw until lock time is released", async () => {
            const { juniorPool, borrowerSupport, juniorLP, usdc, fstInvestor, secInvestor, borrower } = await loadFixture(deployLendingPool);

            const balanceBefore = await usdc.balanceOf(fstInvestor.address);

            await borrowerSupport.connect(borrower).lockJuniorCapital(juniorPool.address);

            await expect(juniorPool.connect(fstInvestor).withdraw(
                "1",
                expandTo18Decimals(1000, 6)
            )).to.be.revertedWith("TL");

            const balanceAfter = await usdc.balanceOf(fstInvestor.address);

            const tokenInfo = await juniorLP.getTokenInfo("1");

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalRedeemed).to.be.equals(0);
            expect(tokenInfo.principalAmount).to.be.equals(expandTo18Decimals(1000, 6));

            expect(balanceAfter).to.be.equals(balanceBefore);
        })

        it("Investor not allow to withdraw exceeds invest principal amount", async () => {
            const { juniorPool, borrowerSupport, juniorLP, usdc, fstInvestor, secInvestor, borrower } = await loadFixture(deployLendingPool);

            const balanceBefore = await usdc.balanceOf(fstInvestor.address);

            await borrowerSupport.connect(borrower).lockJuniorCapital(juniorPool.address);

            await expect(juniorPool.connect(fstInvestor).withdraw(
                "1",
                expandTo18Decimals(10000, 6)
            )).to.be.revertedWith("IA");

            const balanceAfter = await usdc.balanceOf(fstInvestor.address);

            const tokenInfo = await juniorLP.getTokenInfo("1");

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalRedeemed).to.be.equals(0);
            expect(tokenInfo.principalAmount).to.be.equals(expandTo18Decimals(1000, 6));

            expect(balanceAfter).to.be.equals(balanceBefore);
        })

        it("Investor allow to withdraw a portion amount of investment", async () => {
            const { juniorPool, juniorLP, usdc, fstInvestor, secInvestor, borrower } = await loadFixture(deployLendingPool);

            const balanceBefore = await usdc.balanceOf(fstInvestor.address);

            const tx = await juniorPool.connect(fstInvestor).withdraw(
                "1",
                expandTo18Decimals(100, 6)
            );

            const balanceAfter = await usdc.balanceOf(fstInvestor.address);

            const tokenInfo = await juniorLP.getTokenInfo("1");

            expect(tokenInfo.tranche).to.be.equals(2);
            expect(tokenInfo.principalRedeemed).to.be.equals(0);
            expect(tokenInfo.principalAmount).to.be.equals(expandTo18Decimals(900, 6));

            expect(balanceAfter).to.be.equals(balanceBefore.add(expandTo18Decimals(100, 6)));
        })

        it("Other Investor not allow to redeem amount of tokens If they not finish KYC", async () => {
            const { juniorPool, juniorLP, usdc, fstInvestor, secInvestor, borrower } = await loadFixture(deployLendingPool);

            await juniorLP.connect(fstInvestor)["safeTransferFrom(address,address,uint256)"](
                fstInvestor.address,
                borrower.address,
                "1"
            );

            await expect(
                juniorPool.connect(borrower).withdraw(
                    "1",
                    expandTo18Decimals(100, 6)
                )
            ).to.be.revertedWithCustomError(juniorPool, "UnauthorizedCaller");
        })
    });
});