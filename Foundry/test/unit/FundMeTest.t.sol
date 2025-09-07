// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {deployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundme;

    address USER = makeAddr("testUser");
    uint256 constant SENT_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deployFundMe deployer = new deployFundMe();
        fundme = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUSD() public view {
        console.log(fundme.MINIMUM_USD());
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerisMsgSender() public view {
        address owner = fundme.getOwner();
        console.log(owner);
        console.log(msg.sender);
        assertEq(owner, msg.sender) ;
    }

    function testgetVersion() public view {
        uint version = fundme.getVersion();
        assertEq(version, 4);    
        }
    
    function testIfEthFundisEnough() public {
        vm.expectRevert();
        fundme.fund();
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SENT_VALUE}();
        _;
    }   

    function testFundUpdateFundedDataStructure() public funded{
        uint256 amountFunded = fundme.getaddressToAmountFunded(USER);
        assertEq(amountFunded, SENT_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded{
        assertEq(fundme.getFunders(0), USER);
    }

    function testOnlyOwnerCanWIthdraw() public funded{
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    function testWithdrawSingleFunder() public funded {
        //Arrange
        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        //Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        //Assert
        uint endingOwnerBalance = fundme.getOwner().balance;
        uint endingFundMeBalance = address(fundme).balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);

    }

    function testWithdrawMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10; //uint160 is needed when using number for creating address
        uint160 startingFounderIndex = 1; // Don't use 0 in test since there might be sanity check to 0 index
        for (uint160 i = startingFounderIndex; i < numberOfFunders; i++){
            //vm.prank new address
            //vm.deal new address some eth
            hoax(address(i), SENT_VALUE); //hoax does both prank and deal
            // fund the fundme
            fundme.fund{value: SENT_VALUE}();
        }
        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        //Act
        // vm.txGasPrice(GAS_PRICE);
        // uint gasStart = gasleft();
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
        // uint gasEnd = gasleft();
        // uint gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log("Gas used:", gasUsed);

        //Assert
        assert(address(fundme).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundme.getOwner().balance);

    }

    function testCheaperWithdrawMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10; //uint160 is needed when using number for creating address
        uint160 startingFounderIndex = 1; // Don't use 0 in test since there might be sanity check to 0 index
        for (uint160 i = startingFounderIndex; i < numberOfFunders; i++){
            //vm.prank new address
            //vm.deal new address some eth
            hoax(address(i), SENT_VALUE); //hoax does both prank and deal
            // fund the fundme
            fundme.fund{value: SENT_VALUE}();
        }
        uint startingOwnerBalance = fundme.getOwner().balance;
        uint startingFundMeBalance = address(fundme).balance;

        //Act
        // vm.txGasPrice(GAS_PRICE);
        // uint gasStart = gasleft();
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithdraw();
        vm.stopPrank();
        // uint gasEnd = gasleft();
        // uint gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log("Gas used:", gasUsed);

        //Assert
        assert(address(fundme).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundme.getOwner().balance);

    }


}