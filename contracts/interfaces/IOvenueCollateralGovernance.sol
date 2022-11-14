// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "./IOvenueConfig.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";

interface IOvenueCollateralGovernance {
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }

     enum VoteType {
        Against,
        For,
        Abstain
    }
    struct ProposalVote {
        uint256 againstVotes;
        uint256 forVotes;
        mapping(address => bool) hasVoted;
    }
    
    function initialize(
        address _owner,
        address _poolAddr,
        IOvenueConfig _config
    ) external;

    function state(uint256 proposalId) external view returns (ProposalState);
}