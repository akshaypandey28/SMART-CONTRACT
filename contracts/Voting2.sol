// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract Election {
     
    // VOTERS INFORMATION
    struct Voter {
        string name;
        uint number_id;
    }

    // CANDIDATE INFORMATION
    struct Candidate {
        string party;
        uint numvotes;
    }

    // ONCE WHO CAN STARTING THE ELECTION
    address public administrator;
    
    // DECIDE ADMINISTRATOR OF ELECTION
    constructor (address _administrator) {
        administrator = _administrator;
    }

    uint public votes;

    // DECLARING DYNAMIC ARRAY, IN WHICH NO OF CANDIDATES PUSH IN A DYNAMIC ARRAY
    Candidate[] public candidates;

    // VOTER REGISTRATION
    mapping(address => Voter) public voters;

    function registercandi(string memory _name, uint _number) public {
        Candidate memory candi1 = Candidate(_name, _number);
        candidates.push(candi1);
    }

    // ONLY FOR CHECKING IS CANDIDATE IS ADDING OR NOT
    function getcandidate() public view returns (Candidate[] memory) {
    return candidates;
    }



    // VOTER REGISTRATION
    function registervoter( string memory _name, uint _number_id ) public{
    Voter memory newVoter = Voter( _name, _number_id ) ;
    voters[msg.sender] = newVoter ;
    }

    // Function to retrieve voter information
    function getvoter() public view returns( string memory, uint ){
    Voter memory voter = voters[msg.sender] ;
    return ( voter.name, voter.number_id ) ;
    }
    
    function givevote() public {
        // Add voting logic here
    }

    // Event to signal the registration of a new voter
    event VoterRegistered(address indexed voterAddress, string name, uint number_id);
}
