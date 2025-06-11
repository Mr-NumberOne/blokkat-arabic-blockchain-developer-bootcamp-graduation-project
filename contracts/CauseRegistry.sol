// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @dev Reverts if a cause with the given ID is not found.
error CauseNotFound();
/// @dev Reverts if a donation is attempted on an inactive cause.
error CauseNotActive();
/// @dev Reverts if a donation of 0 value is sent.
error DonationMustBeGreaterThanZero();
/// @dev Reverts if the provided wallet address is the zero address.
error WalletAddressCannotBeZero();

/**
 * @title CauseRegistry
 * @author Your Name/Organization
 * @notice A contract to register and manage charitable causes for donations.
 * @dev This contract allows an owner to add, update, and manage causes. Users can donate to active causes.
 */
contract CauseRegistry is Ownable {
    /**
     * @notice Represents a charitable cause in storage.
     */
    struct Cause {
        string name;
        string description;
        string longDescription;
        string imageSrc;
        string category;
        string website;
        uint256 id;
        uint256 goal;
        uint256 raised;
        uint256 donorsCount;
        address payable walletAddress;
        bool isActive;
        bool featured;
    }

    /**
     * @notice A struct to hold the parameters for creating or updating a cause.
     * @dev This is used to avoid "Stack too deep" errors by passing a single struct instead of many arguments.
     */
    struct CauseParams {
        string name;
        string description;
        string longDescription;
        string imageSrc;
        string category;
        uint256 goal;
        string website;
        address payable walletAddress;
        bool isActive;
        bool featured;
    }

    /// @notice Mapping from a cause ID to the Cause struct.
    mapping(uint256 => Cause) public causes;
    /// @dev Mapping to track unique donors for each cause.
    mapping(uint256 => mapping(address => bool)) public hasDonated;
    /// @notice An array containing the IDs of all registered causes.
    uint256[] public causeIds;
    /// @dev A private counter to generate unique IDs for new causes.
    uint256 private causeIdCounter;

    /// @notice Emitted when a new cause is added.
    event CauseAdded(uint256 indexed id, string name);
    /// @notice Emitted when a cause's details are updated.
    event CauseUpdated(uint256 indexed id, string name);
    /// @notice Emitted when a donation is made to a cause.
    event DonationMade(uint256 indexed causeId, address indexed donor, uint256 amount);

    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * @notice Adds a new cause to the registry.
     * @param _params A struct containing all the details for the new cause.
     */
    function addCause(CauseParams calldata _params) public onlyOwner {
        if (_params.walletAddress == address(0)) revert WalletAddressCannotBeZero();

        uint256 newCauseId = ++causeIdCounter;

        causes[newCauseId] = Cause({
            id: newCauseId,
            name: _params.name,
            description: _params.description,
            longDescription: _params.longDescription,
            imageSrc: _params.imageSrc,
            category: _params.category,
            goal: _params.goal,
            raised: 0,
            donorsCount: 0,
            website: _params.website,
            walletAddress: _params.walletAddress,
            isActive: _params.isActive,
            featured: _params.featured
        });

        causeIds.push(newCauseId);
        emit CauseAdded(newCauseId, _params.name);
    }

    /**
     * @notice Updates the details of an existing cause.
     * @param _id The ID of the cause to update.
     * @param _params A struct containing the new details for the cause.
     */
    function updateCause(uint256 _id, CauseParams calldata _params) public onlyOwner {
        Cause storage cause = causes[_id];
        if (cause.id == 0) revert CauseNotFound();
        if (_params.walletAddress == address(0)) revert WalletAddressCannotBeZero();

        cause.name = _params.name;
        cause.description = _params.description;
        cause.longDescription = _params.longDescription;
        cause.imageSrc = _params.imageSrc;
        cause.category = _params.category;
        cause.goal = _params.goal;
        cause.website = _params.website;
        cause.walletAddress = _params.walletAddress;
        cause.isActive = _params.isActive;
        cause.featured = _params.featured;

        emit CauseUpdated(_id, _params.name);
    }

    /**
     * @notice Allows any user to donate Ether to a specific cause.
     */
    function donateToCause(uint256 _id) public payable {
        if (msg.value == 0) revert DonationMustBeGreaterThanZero();

        Cause storage cause = causes[_id];
        if (cause.id == 0) revert CauseNotFound();
        if (!cause.isActive) revert CauseNotActive();

        cause.raised += msg.value;

        if (!hasDonated[_id][msg.sender]) {
            hasDonated[_id][msg.sender] = true;
            cause.donorsCount++;
        }

        (bool success,) = cause.walletAddress.call{value: msg.value}("");
        if (!success) revert();

        emit DonationMade(_id, msg.sender, msg.value);
    }

    /**
     * @notice Retrieves all cause IDs.
     */
    function getAllCauseIds() public view returns (uint256[] memory) {
        return causeIds;
    }

    /**
     * @notice Retrieves a single cause by its ID.
     */
    function getCause(uint256 _id) public view returns (Cause memory) {
        if (causes[_id].id == 0) revert CauseNotFound();
        return causes[_id];
    }
}
