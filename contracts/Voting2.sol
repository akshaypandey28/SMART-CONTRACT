// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Election {

    // Voters Information
    struct Voter {
        string name;
        address number_id;
        bool isRegistered;
        bool hasVoted;
        uint votedFor;
    }

    // Candidate Information
    struct Candidate {
        string party;
        address numberid;
        uint voteCount;
    }

    // Dynamic array to store candidates
    Candidate[] public candidates;

    // Dynamic array to store voters
    Voter[] public voters;

    // Declaration of Admin
    address public admin;

    // Mapping to associate candidate IDs with candidates
    mapping(uint => Candidate) public candidateById;

    // Mapping to associate candidate names with candidate IDs
    mapping(string => uint) public candidateNameToId;

    // Total votes casted
    uint public totalVotes;

    constructor() {
        admin = msg.sender;
    }

    // Modifier for checking Admin is Same Or Not
    modifier owner() {
        require(msg.sender == admin, "Access Denied, Enter correct details for Admin.");
        _;
    }

    // Modifier is checking for candidates register ones only for the same address
    modifier onlyones(address _numberid) {
        require(_numberid != admin, "Admin and Candidate have the same Address");
        uint count = 1;
        if (candidates.length >= 1) {
            for (uint i = 0; i < candidates.length; i++) {
                if (candidates[i].numberid == _numberid) {
                    count = count + 1;
                }
            }
        }
        require(count <= 1 && candidates.length <= 1, "Invalid Doubled Registration");
        _;
    }

    // By Deepak
    // Candidate registration
    function registerCandidate(string memory _name, address _numberid) public owner onlyones(_numberid) {

        Candidate memory newCandidate = Candidate({party: _name, numberid: _numberid, voteCount: 0});
        candidates.push(newCandidate);

        // Associate candidate name with candidate ID
        candidateNameToId[_name] = candidates.length - 1;

        // Emit event for candidate registration
        emit CandidateRegistered(candidates.length - 1, _name, _numberid);
    }

    // By Satyam
    // Voter Registration
    function registerVoter(string memory _name, address _number_id) public owner {
        Voter memory newVoter = Voter(_name, _number_id, true, false, 0);
        voters.push(newVoter);

        // Emit event for voter registration
        emit VoterRegistered(_name, _number_id);
    }

    // Event to signal the registration of a new voter
    event VoterRegistered(string name, address number_id);

    // Event to signal the registration of a new candidate
    event CandidateRegistered(uint indexed candidateId, string name, address numvotes);

    // Voting
    function vote(uint _candidateId) public {
        uint voterIndex;
        for (uint i = 0; i < voters.length; i++) {
            if (voters[i].number_id == msg.sender) {
                voterIndex = i;
                break;
            }
        }

        require(voterIndex < voters.length, "Voter not found.");

        Voter storage voter = voters[voterIndex];
        require(voter.isRegistered, "The voter must be registered.");
        require(!voter.hasVoted, "The voter has already voted.");

        require(_candidateId < candidates.length, "Invalid candidate.");
        voter.hasVoted = true;
        voter.votedFor = _candidateId;
        candidateById[_candidateId].voteCount++;

        // Increment totalVotes when a vote is casted
        totalVotes++;
    }

    // Getting the total number of votes for a candidate
    function getVotes(uint _candidateId) public view returns (uint) {
        require(_candidateId < candidates.length, "Invalid candidate.");
        return candidateById[_candidateId].voteCount;
    }

    // By Shreya Jha
    // Getting the winner of the election
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

    // Function to calculate the percentage of votes for a candidate
    function getPercentageForCandidate(string memory _candidateName) public view returns (uint256) {
        require(bytes(_candidateName).length > 0, "Candidate name cannot be empty");

        uint candidateId = candidateNameToId[_candidateName];
        require(candidateId < candidates.length, "Invalid candidate.");

        // Check if the candidate has received any votes
        if (candidates[candidateId].voteCount == 0) {
            return 0;  // Return 0 if the candidate has received no votes
        }

        // Calculate the percentage using the formula
        return (candidates[candidateId].voteCount * 100) / totalVotes;
    }
}
