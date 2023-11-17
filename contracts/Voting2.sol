// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Election {

    // Voters Information
    struct Voter {
        string name;
        uint number_id;
        bool isRegistered;
        bool hasVoted;
        uint votedFor;
    }

    // Candidate Information
    struct Candidate {
        string party;
        uint numvotes;
        uint voteCount;
    }

    // Dynamic array to store candidates
    Candidate[] public candidates;

    // Mapping to store voter information
    mapping(address => Voter) public voters;
    
   //Decleration of Admin
    address public admin;
     
     constructor(){
      admin = msg.sender;
     }
   
   //Modifier for checking Admin is Same Or Not
    modifier owner(){
      require( msg.sender == admin,"Invalid Due to Owner Is Changed");
      _;
    }
   
    // Candidate registration
    function registerCandidate(string memory _name, uint _number) public owner{
        Candidate memory newCandidate = Candidate({party: _name, numvotes: _number, voteCount: 0});
        candidates.push(newCandidate);

        // Emit event for candidate registration
        emit CandidateRegistered(candidates.length - 1, _name, _number);
    }

    // Voter Registration
    function registerVoter(string memory _name, uint _number_id) public owner {
        require(!voters[msg.sender].isRegistered, "Voter is already registered.");
        Voter memory newVoter = Voter(_name, _number_id, true, false, 0);
        voters[msg.sender] = newVoter;

        // Emit event for voter registration
        emit VoterRegistered(msg.sender, _name, _number_id);
    }

    // Event to signal the registration of a new voter
    event VoterRegistered(address indexed voterAddress, string name, uint number_id);

    // Event to signal the registration of a new candidate
    event CandidateRegistered(uint indexed candidateId, string name, uint numvotes);

    // Mapping to associate candidate IDs with candidates
    mapping(uint => Candidate) public candidateById;

    // Voting
    function vote(uint _candidateId) public owner{
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
    //BY SHREYA JHA
    function getYourWinner() public view returns (uint) {
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
