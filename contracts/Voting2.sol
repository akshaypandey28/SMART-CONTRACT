// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Election {

    // Voters Information
    struct Voter {
        string name;
        address number_id; //changed from type uint to keep simmilar to struct Candidate 
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

    // Constant for NOTA Option
    uint constant NOTA_CANDIDATE_ID = 0;

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
      require( msg.sender == admin,"Access Denied, Enter correct details for Admin.");
      _;
    }
   
   
   // Modifier is checking for candidates register ones only for same address

    modifier onlyones(address _numberid){
       require(_numberid != admin,"Admin and Candidate is same Address");     
         uint count=1;
        if(candidates.length >=1){   
            for(uint i=0;i<candidates.length;i++){
                 if( candidates[i].numberid == _numberid){             // Fetching Candidate number From struct
                     count=count+1;
                  }
            }
        }        
       require(count<=1 && candidates.length<=1,"Invalid Doubled Registration");
       _;

    }


    // Candidate registration
    function registerCandidate(string memory _name, address _numberid) public owner onlyones(_numberid){ 
        // Ensure that NOTA is not registered as a regular candidate
       require(_numberid != NOTA_CANDIDATE_ID, "Invalid candidate ID for NOTA.") ;

        Candidate memory newCandidate = Candidate({party: _name, numberid:_numberid, voteCount: 0}) ;
        candidates.push(newCandidate) ;

        // Emit event for candidate registration
        emit CandidateRegistered(candidates.length - 1, _name, _numberid);
    }

    // By Satyam
    // Voter Registration
    function registerVoter(string memory _name, address _number_id) public owner {
        require(!voters[msg.sender].isRegistered, "Voter is already registered.");
        Voter memory newVoter = Voter(_name, _number_id, true, false, 0);
        voters[msg.sender] = newVoter;

        // Emit event for voter registration
        emit VoterRegistered(msg.sender, _name, _number_id);
    }

    // Event to signal the registration of a new voter
    event VoterRegistered(address indexed voterAddress, string name, address number_id);

    // Event to signal the registration of a new candidate
    event CandidateRegistered(uint indexed candidateId, string name, uint numvotes);

    // Mapping to associate candidate IDs with candidates
    mapping(uint => Candidate) public candidateById;

    // Voting
    function vote(uint _candidateId) public {
        Voter storage voter = voters[msg.sender] ;
        require(voter.isRegistered, "The voter must be registered.") ;
        require(!voter.hasVoted, "The voter has already voted.") ;
        
        // Allow voting for NOTA
        if(_candidateId == NOTA_CANDIDATE_ID) {
            voter.hasVoted = true ;
            voter.votedFor = NOTA_CANDIDATE_ID ;
        }else{
            require(_candidateId < candidates.length, "Invalid candidate.") ;

            voter.hasVoted = true ;
            voter.votedFor = _candidateId ;
            candidateById[_candidateId].voteCount++ ;
        }
    }


    // Getting the total number of votes for a candidate
    function getVotes(uint _candidateId) public view returns (uint) {
        
        // this ensure that the provided candidate ID is valid
        require(_candidateId < candidates.length, "Invalid candidate.");

        // and finally return the vote count for the specified candidate
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
