pragma solidity 0.7.5;
pragma abicoder v2;

contract Multisig {
    address[] ownersadd;
    uint approvalLimit;
    event stepPassed(string mess);
    
    struct Request{
        address owner;
        uint amount;
        uint approvals;
        address payable receiver;
        address payable[] addressesApproved;
    }
    
    Request[] public approved;
    Request[] public pending;
    
    
    
    constructor(address[] memory ownersAddresses,uint approvalLimits ){
        ownersadd = ownersAddresses;
        approvalLimit=approvalLimits;

    }
    
      function deposite() public payable   {
  
    }
    
    function transfer(uint amount,address payable receiver) public payable {
        // create request 
        // append it to pending list
        require(amount<=address(this).balance,"balance is not suffecient");
        address payable[] memory addresses = new address payable[](ownersadd.length);
        addresses[0]=msg.sender;
        Request memory newRequest = Request(msg.sender,amount,1,receiver,addresses);
        pending.push(newRequest);
    }
    
    function listRequest() public view returns(Request[] memory)  {
        return pending;
    }
    function approveTransferRequest(uint index)public {
        // get the request from the array
        // check the number of approvals greater than approvalLimit or not
        // if approvals greate update the requst remove it from pending to accepted 
        // else update the request with the new address 
        // call transfer method so actual payment happen
        Request memory request = pending[index];
        //nt approvals = request.addressesApproved.length;
        request.addressesApproved[request.approvals] = msg.sender;
        request.approvals+=1;
        
        // In cast the request is approved
        if (request.approvals >= approvalLimit){
            delete pending[index];
            approved.push(request);
            request.receiver.transfer(request.amount);
            }
        }
    
    
    function getWalletBalance() public payable returns (uint){
        //return msg.value;
        return address(this).balance;
    }
    
}


