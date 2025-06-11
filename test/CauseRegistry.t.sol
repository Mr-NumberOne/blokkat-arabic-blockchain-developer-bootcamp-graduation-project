// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../contracts/CauseRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// A helper contract that reverts when it receives Ether, used for testing transfer failures.
contract RevertingReceiver {
    receive() external payable {
        revert("Payment rejected");
    }
}

/**
 * @title Base Test Contract for CauseRegistry
 * @dev This contract contains the setup logic and helper functions
 * that are shared across all test suites.
 */
contract CauseRegistryTest is Test {
    /// @dev The contract instance being tested.
    CauseRegistry public causeRegistry;
    /// @dev A mapping to store and manage test user addresses by role.
    mapping(string => address) public users;

    /**
     * @dev Sets up the test environment before each test case runs.
     */
    function setUp() public {
        users["owner"] = makeAddr("owner");
        users["donor1"] = makeAddr("donor1");
        users["donor2"] = makeAddr("donor2");
        users["randomUser"] = makeAddr("randomUser");

        vm.prank(users["owner"]);
        causeRegistry = new CauseRegistry(users["owner"]);

        vm.deal(users["donor1"], 10 ether);
        vm.deal(users["donor2"], 10 ether);
    }

    /**
     * @dev Internal helper function to create a CauseParams struct with default values.
     * @return params A CauseParams struct populated with default data.
     */
    function _createDefaultParams() internal returns (CauseRegistry.CauseParams memory params) {
        return CauseRegistry.CauseParams({
            name: "Default Cause",
            description: "A default description.",
            longDescription: "A default long description.",
            imageSrc: "default.url",
            category: "Default",
            goal: 100 ether,
            website: "default.site",
            walletAddress: payable(makeAddr("defaultCauseWallet")),
            isActive: true,
            featured: false
        });
    }

    /**
     * @dev Internal helper function to add a default cause to the registry for use in multiple tests.
     */
    function _addDefaultCause() internal {
        vm.prank(users["owner"]);
        causeRegistry.addCause(_createDefaultParams());
    }

    /**
     * @dev Internal helper function to add a default cause with a specific recipient wallet address.
     * @param wallet The address to be set as the cause's donation recipient.
     */
    function _addDefaultCauseWithWallet(address payable wallet) internal {
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        params.walletAddress = wallet;
        causeRegistry.addCause(params);
    }
}

// =============================================
//      Tests for the addCause function
// =============================================
contract AddCauseTests is CauseRegistryTest {
    /**
     * @dev Tests if the owner can successfully add a new cause.
     */
    function test_addCause_succeeds() public {
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        vm.expectEmit(true, true, true, true);
        emit CauseRegistry.CauseAdded(1, params.name);
        causeRegistry.addCause(params);
        CauseRegistry.Cause memory cause = causeRegistry.getCause(1);
        assertEq(cause.id, 1);
        assertEq(cause.name, params.name);
    }

    /**
     * @dev Tests that addCause reverts if called by a non-owner.
     */
    function test_revert_if_addCause_isCalledBy_nonOwner() public {
        vm.prank(users["randomUser"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        bytes memory expectedRevertData =
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, users["randomUser"]);
        vm.expectRevert(expectedRevertData);
        causeRegistry.addCause(params);
    }

    /**
     * @dev Tests that addCause reverts if the wallet address is the zero address.
     */
    function test_revert_if_addCause_has_zeroAddressWallet() public {
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        params.walletAddress = payable(address(0));
        vm.expectRevert(WalletAddressCannotBeZero.selector);
        causeRegistry.addCause(params);
    }
}

// =============================================
//      Tests for the updateCause function
// =============================================
contract UpdateCauseTests is CauseRegistryTest {
    /**
     * @dev Tests if the owner can successfully update an existing cause.
     */
    function test_updateCause_succeeds() public {
        _addDefaultCause();
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory updatedParams = _createDefaultParams();
        updatedParams.name = "Updated Cause Name";
        vm.expectEmit(true, true, true, true);
        emit CauseRegistry.CauseUpdated(1, updatedParams.name);
        causeRegistry.updateCause(1, updatedParams);
        CauseRegistry.Cause memory cause = causeRegistry.getCause(1);
        assertEq(cause.name, "Updated Cause Name");
    }

    /**
     * @dev Tests that updateCause reverts if updating a non-existent cause.
     */
    function test_revert_if_updateCause_for_nonExistentCause() public {
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        vm.expectRevert(CauseNotFound.selector);
        causeRegistry.updateCause(999, params);
    }

    /**
     * @dev Tests that updateCause reverts if the new wallet address is the zero address.
     */
    function test_revert_if_updateCause_has_zeroAddressWallet() public {
        _addDefaultCause();
        vm.prank(users["owner"]);
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        params.walletAddress = payable(address(0));
        vm.expectRevert(WalletAddressCannotBeZero.selector);
        causeRegistry.updateCause(1, params);
    }
}

// =============================================
//      Tests for the donateToCause function
// =============================================
contract DonateToCauseTests is CauseRegistryTest {
    /**
     * @dev Tests a successful donation to a cause.
     */
    function test_donateToCause_succeeds() public {
        address causeWallet = makeAddr("causeWallet");
        _addDefaultCauseWithWallet(payable(causeWallet));
        vm.prank(users["donor1"]);
        vm.expectEmit(true, true, true, true);
        emit CauseRegistry.DonationMade(1, users["donor1"], 1 ether);
        causeRegistry.donateToCause{value: 1 ether}(1);
        CauseRegistry.Cause memory cause = causeRegistry.getCause(1);
        assertEq(cause.raised, 1 ether);
        assertEq(cause.donorsCount, 1);
        assertEq(causeWallet.balance, 1 ether);
    }

    /**
     * @dev Tests that the donor count only increments for unique donors.
     */
    function test_donateToCause_incrementsDonorCount_onlyOncePerDonor() public {
        _addDefaultCause();
        vm.prank(users["donor1"]);
        causeRegistry.donateToCause{value: 1 ether}(1);
        vm.prank(users["donor1"]);
        causeRegistry.donateToCause{value: 0.5 ether}(1);
        vm.prank(users["donor2"]);
        causeRegistry.donateToCause{value: 2 ether}(1);
        CauseRegistry.Cause memory cause = causeRegistry.getCause(1);
        assertEq(cause.donorsCount, 2, "Donor count should be 2 for two unique donors");
    }

    /**
     * @dev Tests that donating with a value of 0 reverts.
     */
    function test_revert_if_donate_with_zeroValue() public {
        _addDefaultCause();
        vm.prank(users["donor1"]);
        vm.expectRevert(DonationMustBeGreaterThanZero.selector);
        causeRegistry.donateToCause{value: 0}(1);
    }

    /**
     * @dev Tests that donating to an inactive cause reverts.
     */
    function test_revert_if_donate_to_inactiveCause() public {
        CauseRegistry.CauseParams memory params = _createDefaultParams();
        params.isActive = false;
        vm.prank(users["owner"]);
        causeRegistry.addCause(params);
        vm.prank(users["donor1"]);
        vm.expectRevert(CauseNotActive.selector);
        causeRegistry.donateToCause{value: 1 ether}(1);
    }

    /**
     * @dev Tests that donating to a non-existent cause reverts.
     */
    function test_revert_if_donate_to_nonExistentCause() public {
        vm.prank(users["donor1"]);
        vm.expectRevert(CauseNotFound.selector);
        causeRegistry.donateToCause{value: 1 ether}(999);
    }

    /**
     * @dev Tests that the entire donation function reverts if the final Ether transfer fails.
     */
    function test_revert_if_donationTransferFails() public {
        RevertingReceiver receiver = new RevertingReceiver();
        _addDefaultCauseWithWallet(payable(address(receiver)));
        vm.prank(users["donor1"]);
        vm.expectRevert();
        causeRegistry.donateToCause{value: 1 ether}(1);
    }
}

// =============================================
//      Tests for the getCause function
// =============================================
contract GetCauseTests is CauseRegistryTest {
    /**
     * @dev Tests that getCause reverts if called for a non-existent cause.
     */
    function test_revert_if_getCause_for_nonExistentCause() public {
        vm.expectRevert(CauseNotFound.selector);
        causeRegistry.getCause(999);
    }
}
