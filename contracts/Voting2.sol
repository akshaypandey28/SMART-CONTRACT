//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract Election {

    // VOTERS INFORMATION
    struct Voter {
        string name;
        uint number_id;
        bool isRegistered;
        bool hasVoted;
        uint votedFor;
    }

    // CANDIDATE INFORMATION
    struct Candidate {
        string party;
        uint numvotes;
        uint voteCount;
    }

    // DECIDE ADMINISTRATOR OF ELECTION
    address public administrator;
    
    // DYNAMIC ARRAY TO STORE NO OF CANDIDATES
    Candidate[] public candidates;

    // CANDIDATE REGISTRATION
    mapping(address => Voter) public voters;

    function registercandi(string memory _name, uint _number) public {
        Candidate memory candi1 = Candidate({party: _name, numvotes: _number, voteCount:0});
        candidates.push(candi1);
    }

    // VOTER REGISTRATION
    function registervoter( string memory _name, uint _number_id ) public{
    Voter memory newVoter = Voter( _name, _number_id, true, false, 0 ) ;
    voters[msg.sender] = newVoter ;
    }

    // Event to signal the registration of a new voter
    event VoterRegistered(address indexed voterAddress, string name, uint number_id);

    // Function to retrieve voter information
    function getvoter() public view returns( string memory, uint ){
    Voter memory voter = voters[msg.sender] ;
    return ( voter.name, voter.number_id ) ;
    }
    
    // Mapping to associate candidate IDs with candidates
    mapping(uint => Candidate) public candidateById;

    // Event to signal the registration of a new candidate
    event CandidateRegistered(uint indexed candidateId, string name, uint numvotes);

    
    // Voting
    function vote(uint _candidateId) public {
        Voter storage voter = voters[msg.sender];
        require(voter.isRegistered, "The voter must be registered.");
        require(!voter.hasVoted, "The voter has already voted.");
        require(_candidateId < candidates.length, "Invalid candidate.");

        voter.hasVoted = true;
        voter.votedFor = _candidateId;
        candidateById[_candidateId].voteCount++;
    }

    // Getting the total number of votes for a candidate
    function getVotes(uint _candidateId) public view returns (uint) {
        require(_candidateId < candidates.length, "Invalid candidate.");
        return candidateById[_candidateId].voteCount;
    }

    // Getting the winner of the election
    function getWinner() public view returns (uint) {
        uint winnerId = 0;
        uint maxVotes = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidateById[i].voteCount > maxVotes) {
                maxVotes = candidateById[i].voteCount;
                winnerId = i;
            }
        }

        return winnerId;
    }
}