// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {price_converter} from "./price_converter.sol";

//error notAuthorized();

contract fund_me {

    using price_converter for uint256;

    address [] public funders;
    mapping (address => uint) public AddressToAmmountFunded;

    // Using constant and immutable for gas saving: https://docs.soliditylang.org/en/latest/contracts.html#constant-and-immutable-state-variables
    // Both for variables with static value, constant for decalaration directly while immutable for declaration in a 'function'

    uint public constant MINIMUM_USD = 5e18;

    address public immutable i_owner;

    constructor () {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        // if (msg.sender != i_owner) {
        //     revert notAuthorized();
        // } More gas friendly for using revert
        require(msg.sender == i_owner, "Not Authorized!");
        _;
    }


    function fund() public payable {
        require (msg.value.getConversionValue() >= MINIMUM_USD, "Not enough ETH!");
        funders.push(msg.sender);
        AddressToAmmountFunded[msg.sender] += msg.value;
    }


    function withdraw() public onlyOwner{
        for(uint _index; _index < funders.length; _index++) {
            address _funder = funders[_index];
            AddressToAmmountFunded[_funder] = 0;
        }

        funders = new address[](0);

        //Withdraw, 3 ways to withdraw fund : https://www.cyfrin.io/glossary/sending-ether-transfer-send-call-solidity-code-example

        //payable(msg.sender).transfer(address(this).balance);
        //bool isSuccess = payable(msg.sender).send(address(this).balance);

        (bool isSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(isSuccess, "Transaction Failed");

    }

    // Special functions: https://docs.soliditylang.org/en/latest/contracts.html#special-functions

    receive() external payable {
        fund();
    }

    fallback() external  payable { 
        fund();
    }
}