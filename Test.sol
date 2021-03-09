pragma solidity >=0.7.0 <0.8.0;

contract Test {
    enum RequestType {NewHome, EditHome}
    
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
    }
    
    struct Request{
        RequestType requestType;
        Home home;
        uint result;
        address adr;
    }
    
    struct Home{
        string homeAddress;
        uint area;
        uint cost;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
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
   
}
