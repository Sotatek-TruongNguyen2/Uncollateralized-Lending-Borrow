// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../upgradeable/BaseUpgradeablePausable.sol";
import "./GovernorVotesUpgradeable.sol";
import "../libraries/OvenueConfigHelper.sol";
import "../libraries/OvenueCollateralGovernanceLogic.sol";
import "../interfaces/IOvenueJuniorLP.sol";
import "../interfaces/IOvenueConfig.sol";
import "../interfaces/IOvenueCollateralGovernance.sol";

contract OvenueCollateralGovernance is
    BaseUpgradeablePausable,
    GovernorVotesUpgradeable
{
    error PoolVotingMismatched();
    error WrongTokenInfoOwner();

    IOvenueConfig config;
    using OvenueConfigHelper for IOvenueConfig;
    
    address poolAddr;
    IOvenueJuniorLP juniorLP;

    uint256 private _votingDelay;
    uint256 private _votingPeriod;
    uint256 private _quorumNumerator;

    mapping(uint256 => IOvenueCollateralGovernance.ProposalVote) private _proposalVotes;

    event VotingDelaySet(uint256 oldVotingDelay, uint256 newVotingDelay);
    event VotingPeriodSet(uint256 oldVotingPeriod, uint256 newVotingPeriod);

    function initialize(
        address _owner,
        address _poolAddr,
        IOvenueConfig _config
    ) external initializer {
        __BaseUpgradeablePausable__init(_owner);

        __Governor_init("OVN Collateral DAO");
        __GovernorVotes_init(IVotesUpgradeable(_config.fiduAddress()));

        juniorLP = IOvenueJuniorLP(_config.juniorLPAddress());
        config = _config;
        poolAddr = _poolAddr;
        _votingDelay = config.getCollateralVotingDelay();
        _votingPeriod = config.getCollateralVotingPeriod();
        _quorumNumerator = config.getCollateralQuorumNumerator();
    }

     /**
     * @dev See {IGovernor-castVote}.
     */
    function castNFTVote(uint256 proposalId, uint tokenId, uint8 support) public virtual returns (uint256) {
        address voter = _msgSender();
        return _castVotewithNFT(proposalId, tokenId, voter, support, "", "");
    }

    /**
     * @dev See {IGovernor-castVoteWithReason}.
     */
    function castNFTVoteWithReason(
        uint256 proposalId,
        uint tokenId,
        uint8 support,
        string calldata reason
    ) public virtual returns (uint256) {
        address voter = _msgSender();
        return _castVotewithNFT(proposalId, tokenId, voter, support, reason, "");
    }

    function _castVotewithNFT(
        uint256 proposalId,
        uint256 tokenId,
        address account,
        uint8 support,
        string memory reason,
        bytes memory params
    ) internal returns (uint256) {
        IOvenueJuniorLP.TokenInfo memory tokenInfo = juniorLP.getTokenInfo(
            tokenId
        );

        if (tokenInfo.pool != poolAddr) {
            revert PoolVotingMismatched();
        }

        if (!juniorLP.isApprovedOrOwner(msg.sender, tokenId)) {
            revert WrongTokenInfoOwner();
        }

        if (state(proposalId) != IOvenueCollateralGovernance.ProposalState.Active) {
            revert ProposalNotActive();
        }

        uint256 weight = tokenInfo.principalAmount;
        _countVote(proposalId, account, support, weight, params);

        if (params.length == 0) {
            emit VoteCast(account, proposalId, support, weight, reason);
        } else {
            emit VoteCastWithParams(account, proposalId, support, weight, reason, params);
        }

        return weight;
    }

    /**
     * @dev See {IGovernor-COUNTING_MODE}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function COUNTING_MODE()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return "support=bravo&quorum=for,abstain";
    }

    /**
     * @dev See {IGovernor-hasVoted}.
     */
    function hasVoted(uint256 proposalId, address account)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _proposalVotes[proposalId].hasVoted[account];
    }

    /**
     * @dev Accessor to the internal vote counts.
     */
    function proposalVotes(uint256 proposalId)
        public
        view
        virtual
        returns (
            uint256 againstVotes,
            uint256 forVotes
        )
    {
        IOvenueCollateralGovernance.ProposalVote storage proposalVote = _proposalVotes[proposalId];
        return (
            proposalVote.againstVotes,
            proposalVote.forVotes        
        );
    }

    // /**
    //  * @dev See {Governor-_countVote}. In this module, the support follows the `VoteType` enum (from Governor Bravo).
    //  */
    function _countVote(
        uint256 proposalId,
        address account,
        uint8 support,
        uint256 weight,
        bytes memory params
    ) internal virtual override {
        OvenueCollateralGovernanceLogic.countVote(
            _proposalVotes,
            proposalId,
            account,
            support,
            weight,
            params
        );
    }

    /**
     * @dev See {Governor-_quorumReached}.
     */
    function _quorumReached(uint256 proposalId)
        internal
        view
        virtual
        override
        returns (bool)
    {
        IOvenueCollateralGovernance.ProposalVote storage proposalvote = _proposalVotes[proposalId];
        return quorum(proposalSnapshot(proposalId)) <= proposalvote.forVotes;
    }

    /**
     * @dev See {Governor-_voteSucceeded}. In this module, the forVotes must be scritly over the againstVotes.
     */
    function _voteSucceeded(uint256 proposalId)
        internal
        view
        virtual
        override
        returns (bool)
    {
        IOvenueCollateralGovernance.ProposalVote storage proposalvote = _proposalVotes[proposalId];
        return proposalvote.forVotes > proposalvote.againstVotes;
    }

    /**
     * @dev See {IGovernor-votingDelay}.
     */
    function votingDelay() public view virtual override returns (uint256) {
        return _votingDelay;
    }

    /**
     * @dev See {IGovernor-votingPeriod}.
     */
    function votingPeriod() public view virtual override returns (uint256) {
        return _votingPeriod;
    }

    function quorumNumerator() public view virtual returns (uint256) {
        return _quorumNumerator;
    }

    // function quorumDenominator() public view virtual returns (uint256) {
    //     return 100;
    // }

    function quorum(uint256 blockNumber)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return
            (token.getPastTotalSupply(blockNumber) * quorumNumerator()) / 100;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(GovernorUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
