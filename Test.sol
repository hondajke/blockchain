pragma solidity >=0.7.0 <=0.8.2;

contract Owned{
    address private owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier OnlyOwner{
        require(
            msg.sender == owner,
            'Only owner can run this function!'
            );
        _;
    }
    
    function ChangeOwner(address newOwner) public OnlyOwner{
        owner = newOwner;
    }
    
    function GetOwner() public returns (address){
        return owner;
    }
}


contract Reestr is Owned {
    enum RequestType {NewHome, EditHome}
    enum OwnerOperationType {NewOwner, ChangeOwner, AddOwner}
    uint private cost = 100 wei;
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    address[] requestInitiator;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    uint private amount;
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }

    struct Owner{
        string name;
        uint pass_ser;
        uint pass_num;
        uint256 pass_date;
        string phone_number;
    }
    
    struct Employee{
        string nameEmpl;
        string position;
        string phone_number;
        bool isset;
    }
    
    struct Request{
        RequestType requestType;
        //Home home;
        string homeAddr;
        uint homeArea;
        uint homeCost;
        uint result;
        OwnerOperationType ownType;
        address adr;
        bool isProcessed;
    }
    
    struct Home{
        string homeAddress;
        uint area;
        uint cost;
    }
    
    
    
    modifier OnlyEmployee{
        require(
            employees[msg.sender].isset != false,
            'Only Employee can run this function!'
            );
            _;
    }
    
    modifier Costs(uint value){
        require(
            msg.value >= value,
            'Not enough funds!!'
            );
        _;
    }
    
    function AddHome(string memory _adr, uint _area, uint _cost) public {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns (uint _area, uint _cost){
        return (homes[adr].area, homes[adr].cost);
    }
    
    function AddEmployee(address id, string memory _name, string memory _position, string memory _phoneNumber) public OnlyOwner{
        Employee memory e;
        e.nameEmpl = _name;
        e.position = _position;
        e.phone_number = _phoneNumber;
        e.isset = true;
        employees[id] = e;
    }
    
    function GetEmployee(address id) public OnlyEmployee OnlyOwner returns (string memory _name, string memory _position, string memory _phoneNumber){
        return (employees[id].nameEmpl, employees[id].position, employees[id].phone_number);
    }
    
    function EditEmployee(address _id, string memory _newname, string memory _newposition, string memory _newphoneNumber) public OnlyEmployee OnlyOwner{
        employees[_id].nameEmpl = _newname;
        employees[_id].position = _newposition;
        employees[_id].phone_number = _newphoneNumber;
    }
   
    function DeleteEmployee(address id) public OnlyOwner{
        delete employees[id];
    }
    
    function AddRequest(uint rType, string memory adr, uint area, uint cost, address newOwner) public Costs(cost) payable returns (bool)
    {
        Request memory r;
        r.requestType = rType == 0? RequestType.NewHome: RequestType.EditHome;
        r.homeAddr = adr;
        r.homeArea = area;
        r.homeCost = cost;
        r.result = 0;
        r.adr = rType==0?address(0):newOwner;
        r.isProcessed = false;
        requests[msg.sender] = r;
        requestInitiator.push(msg.sender);
        amount += msg.value;
        return true;
    }
    
    function GetRequest() public OnlyEmployee returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestInitiator.length);
        uint[] memory types = new uint[](requestInitiator.length);
        string[] memory homeAddresses = new string[](requestInitiator.length);
        for(uint i=0;i!=requestInitiator.length;i++){
            ids[i] = i;
            types[i] = requests[requestInitiator[i]].requestType == RequestType.NewHome ? 0: 1;
            homeAddresses[i] = requests[requestInitiator[i]].homeAddr;
        }
        return (ids, types, homeAddresses);
    }
    
    function RequestPending(uint id) public OnlyEmployee returns (bool){
        if(!requests[requestInitiator[id]].isProcessed){
            requests[requestInitiator[id]].isProcessed = true;
            return true;
        }
        return false;
    }
    
    function EditCost(uint _cost) public OnlyOwner
    {
        cost = _cost;
    }
    
    function GetCost() public returns (uint _cost){
        return cost;
    }
    
}
