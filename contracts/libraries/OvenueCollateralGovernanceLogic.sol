// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../interfaces/IOvenueCollateralGovernance.sol";
// import "@openzeppelin/contracts-upgradeable/governance/IGovernorUpgradeable.sol";

library OvenueCollateralGovernanceLogic{
    error InvalidVotingType();
    error VoteAlreadyBeenCasted();
    function countVote(
        mapping(uint256 => IOvenueCollateralGovernance.ProposalVote) storage _proposalVotes,
        uint256 _proposalId,
        address _account,
        uint8 _support,
        uint256 _weight,
        bytes memory _params
    ) external {
        IOvenueCollateralGovernance.ProposalVote storage proposalvote = _proposalVotes[_proposalId];

        // require(
        //     weight >= votingThreshold(),
        //     "GovernorVotingSimple: Minimum Holding not reached"
        // );
        if (proposalvote.hasVoted[_account]) {
            revert VoteAlreadyBeenCasted();
        }

        proposalvote.hasVoted[_account] = true;

        if (_support == uint8(IOvenueCollateralGovernance.VoteType.Against)) {
            proposalvote.againstVotes += _weight;
        } else if (_support == uint8(IOvenueCollateralGovernance.VoteType.For)) {
            proposalvote.forVotes += _weight;
        } else {
            revert InvalidVotingType();
            // revert("GovernorVotingSimple: invalid value for enum VoteType");
        }
    }
}