// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {deployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionTest is Test {
    FundMe fundme;

    address USER = makeAddr("testUser");
    uint256 constant SENT_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 1 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deployFundMe deployer = new deployFundMe();
        fundme = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // FundFundMe fundFundMe = new FundFundMe();
        // fundFundMe.fundFundMe(address(fundme));
        vm.prank(USER);
        fundme.fund{value: SENT_VALUE}();

        address funder = fundme.getFunders(0);
        assertEq(funder, USER);
    }

    function testUserCanWIthdrawInteractions() public {
        // FundFundMe fundFundMe = new FundFundMe();
        // fundFundMe.fundFundMe(address(fundme));
        vm.prank(USER);
        fundme.fund{value: SENT_VALUE}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assert(address(fundme).balance == 0);
    }


}