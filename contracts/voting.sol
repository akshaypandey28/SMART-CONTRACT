//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract election{
     
     //VOTERS  INFORMAITION

     struct Voter{
        string name;
        uint number_id;
     }

     //CANDIDATE INFORMATION

     struct Candidate{
        string party;
        uint numvotes;
     }

     //ONCE WHO CAN STARTING THE ELECTION

     address public administrator;
    
    //DECIDE ADMINISTRATOR OF ELECTION

     constructor (address _administrator){
        administrator = _administrator;
     }
     

     uint public votes;

     // DECLEARING DYNAMIC ARRAY, IN WHICH NO OF CANDIDATES PUSH IN A DYNAMIC ARRAY
        Candidate[] public candidates;

     
     // REGISTRATION OF CANDIDATE
   
     function  registercandi(string memory _name,uint _number) public {

        Candidate memory candi1 = Candidate(_name,_number);
        candidates.push(candi1);

     }


     // ONLY FOR CHECKING IS CANDIDATE IS ADDING OR NOT

     function getcandidate(uint _candinoo) public view returns(Candidate[] memory){
     
     Candidate[] memory can = new Candidate[](_candinoo);

      return can;
     }


     mapping(address => Voter) public voters;

    


}