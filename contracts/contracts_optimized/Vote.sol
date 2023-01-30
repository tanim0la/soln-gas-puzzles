// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedVote {
    struct Voter {
        uint8 vote;
        bool voted;
    }

    struct Proposal {
        uint8 voteCount;
        bytes32 name;
        bool ended;
    }

    mapping(address => Voter) public voters;

    Proposal[] proposals;

    function createProposal(bytes32 _name) external returns (uint256 counter) {
        assembly {
            counter := sload(proposals.slot)
        }
        proposals.push();
        Proposal storage newProposal = proposals[counter++];
        newProposal.name = _name;
    }

    function vote(uint8 _proposal) external {
        Voter storage voter = voters[msg.sender];
        require(!voter.voted, 'already voted');
        voter.vote = _proposal;
        voter.voted = true;

        proposals[_proposal].voteCount += 1;
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
        return proposals[_proposal].voteCount;
    }
}

// contract OptimizedVote {
//     struct Voter {
//         uint8 vote;
//         bool voted;
//     }

//     struct Proposal {
//         uint8 voteCount;
//         bytes32 name;
//         bool ended;
//     }

//     mapping(address => Voter) public voters;

//     Proposal[] proposals;

//     function createProposal(bytes32 _name) external {
//         proposals.push(Proposal({voteCount: 0, name: _name, ended: false}));
//     }

//     function vote(uint8 _proposal) external {
//         require(!voters[msg.sender].voted, 'already voted');
//         voters[msg.sender].vote = _proposal;
//         voters[msg.sender].voted = true;

//         proposals[_proposal].voteCount += 1;
//     }

//     function getVoteCount(uint8 _proposal) external view returns (uint8) {
//         return proposals[_proposal].voteCount;
//     }
// }
