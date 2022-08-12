//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CryptoKids{

    address owner;

    constructor(){
        owner = msg.sender;
    }

    struct Kids{
        address payable walletAddress;
        string name;
        uint256 releaseDate;
        uint256 amount;
        bool canWithdraw;
    }

    Kids[] public kids;

    mapping(string => address) nameToAddress;

    mapping(string => uint256) nameToReleaseDate;

    function addKids(address payable _walletAddress, string memory _name, uint256 _releaseDate, uint256 _amount, bool _canWithdraw) public{
        kids.push(Kids({
            walletAddress: _walletAddress,
            name: _name,
            releaseDate: _releaseDate,
            amount: _releaseDate,
            canWithdraw: _canWithdraw
        }));

        nameToAddress[_name] = _walletAddress;
        nameToReleaseDate[_name] = _releaseDate;

    }

    function balance() public view returns(uint256){
        return address(this).balance;
    }

    function deposit(address payable _walletAddress) payable public{
        for(uint256 i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == _walletAddress){
                kids[i].amount += msg.value;
            }
        }
    }

    function availableToWithdraw(address _walletAddress) public view returns(bool){
        for(uint256 i = 0; i < kids.length; i++){
            if((kids[i].walletAddress == _walletAddress) && (kids[i].releaseDate >= block.timestamp)){
                return true;
            }
        }
        return false;
    }

    function withdraw(address payable _walletAddress) payable public{
        for(uint256 i = 0; i < kids.length; i++){
            require(msg.sender == kids[i].walletAddress, "You Muct Be One Of The Kids To Withdraw");
            require(kids[i].canWithdraw == true, "You are not able to withdraw at this time");
            _walletAddress.transfer(kids[i].amount);
        }
    }


}