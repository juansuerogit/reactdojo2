pragma solidity ^0.4.20;

contract DecentralizedSchedule {
   
    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name; 
        int128 voteCount; // number of accumulated votes
    }

    struct UserVote {
        bool voted;
        uint proposalIndex;
    }

    struct Voting {
        string name;
        Proposal[] proposals;
        mapping(address => UserVote) votes;
    }

    // Key here is the unique address generated for each voting, called "signer"
    mapping(address => Voting) public votings;

    function voteSummary(address signer) public constant returns (string, bytes32[], int128[]) {
        return (votings[signer].name, proposalNames(signer), voteCounts(signer));
    }
    
    function voteCounts(address signer) public constant returns (int128[]) {
        Proposal[] storage ps = votings[signer].proposals;
        int128[] memory arr = new int128[](ps.length);
        for (uint i = 0; i < ps.length; i++) {
            arr[i] = ps[i].voteCount;
        }
        return arr;
    }

    function proposalNames(address signer) public constant returns (bytes32[] namesarr) {
        Proposal[] storage ps = votings[signer].proposals;
        bytes32[] memory arr = new bytes32[](ps.length);
        for (uint i = 0; i < ps.length; i++) {
            arr[i] = ps[i].name;
        }
        return arr;
    }


    function proposalName(address signer, uint8 proposalIndex) public constant returns (bytes32 name) {
        return votings[signer].proposals[proposalIndex].name;
    }
    
    function isEmpty(string str) pure public returns (bool)  {
        bytes memory tempEmptyStringTest = bytes(str);
        return (tempEmptyStringTest.length == 0);
    }
    
    function create(address signer, string name, bytes32[] proposalNamess) public {
        Voting storage voting = votings[signer];
        require(isEmpty(voting.name));
               
        /* // TODO validations of proposalNamess, escape etc. */
        for (uint i = 0; i < proposalNamess.length; i++) {                        
            voting.proposals.push(Proposal({
                name: proposalNamess[i],
                voteCount: 0
            }));
        }
        voting.name = name;
        votings[signer] = voting;
    }

    event VoteSingle(address voter, address indexed signer, string voterName, uint8 proposal);

    function addressToString(address x) pure public returns (string) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
            byte hi = byte(uint8(b) / 16);
            byte lo = byte(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);            
        }
        return string(s);
    }

    function char(byte b) pure public returns (byte c)  {
        if (b < 10) return byte(uint8(b) + 0x30);
        else return byte(uint8(b) + 0x57);
    }
        
    function addressKeccak(address addr) pure public returns(bytes32) {
        // The "42" here stands for string length of an address
        return keccak256("\x19Ethereum Signed Message:\n420x", addressToString(addr));
    }

    function vote(string name, uint8 proposal, bytes32 prefixedSenderHash, bytes32 r, bytes32 s, uint8 v) public returns (uint256) {
        // compare hashes -> this way no one can send votes as other users
        require(addressKeccak(msg.sender) == prefixedSenderHash);
        // derive signer from the signature
        address signer = ecrecover(prefixedSenderHash, v, r, s);
        Voting storage voting = votings[signer];
        require(!isEmpty(voting.name));
        require(proposal < voting.proposals.length);

        UserVote storage prevVote = voting.votes[msg.sender];
        if (prevVote.voted) {
            voting.proposals[prevVote.proposalIndex].voteCount -= 1;
        }
        else {
            voting.votes[msg.sender].voted = true;
        }
        
        voting.votes[msg.sender].proposalIndex = proposal;
    
        voting.proposals[proposal].voteCount += 1;

        emit VoteSingle (msg.sender, signer, name, proposal);

    } 
}