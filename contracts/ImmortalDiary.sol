pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

/**
 * Immortal Diary of Dario Anongba Varela and Nativity Carol.
 * Most important moments of our live. Use it wisely, as you cannot go back!
 */
contract ImmortalDiary is Ownable {    

    /* --- Structures --- */
    struct Event {
        string description;
        uint256 date;
        string location;
        address by;
    }

    struct Owner {
        address account;
        string name;
    }

    /* --- Constants --- */
    string public name;
    string public description;
    uint256 public creationDate;

    /* --- Variables --- */
    uint256 public nbEvents;

    mapping (address => Owner) public funders;
    mapping (address => Owner) public owners;
    mapping (uint256 => Event) public events;

    /* --- Events --- */
    event FunderAdded(address indexed by, address indexed account, string name, uint256 date);
    event OwnerAdded(address indexed by, address indexed account, string name, uint256 date);
    event OwnerRemoved(address indexed by, address indexed account, string name, uint256 date);
    event EventAdded(address indexed by, uint256 eventId, uint256 date);

    /* --- Modifiers --- */

    /**
    * @dev Checks that account is a funder
    */
    modifier onlyFundersOrOwner() {
        require(isOwner() || isFunder(msg.sender), "Not a funder");
        _;
    }

    /**
    * @dev Checks that account is an owner (funders are among owners)
    */
    modifier onlyOwners() {
        require(isOwner() || isOwner(msg.sender), "Not an owner");
        _;
    }

    /* --- Public functions --- */

    /**
     * @dev Creates a new immortal diary with a name and a description
     * @param diaryName The name of the diary
     * @param diaryDescription The description of the diary. What will this diary be used for?
     */
    constructor(string memory diaryName, string memory diaryDescription) public {
        name = diaryName;
        description = diaryDescription;
        creationDate = now;
    }

    /**
    * @dev Verifies that a given account is a funder
    *
    * @param account The address to verify
    * @return true if account is a funder, false otherwise
    */
    function isFunder(address account) public view returns (bool) {
        return funders[account].account != address(0);
    }

    /**
    * @dev Verifies that a given account is an owner
    *
    * @param account The address to verify
    * @return true if account is an owner, false otherwise
    */
    function isOwner(address account) public view returns (bool) {
        return super.isOwner() || owners[account].account != address(0);
    }

    /**
    * @dev Owner of the diary can add fudners to it
    *
    * @param account The account of the funder to add
    * @param funderName The name of the funder to add
    */
    function addFunder(address account, string memory funderName) public onlyOwner() {
        require(account != address(0), "cannot be 0x0 address");

        Owner memory newFunder;
        newFunder.account = account;
        newFunder.name = funderName;

        funders[account] = newFunder;
        owners[account] = newFunder;
        emit FunderAdded(msg.sender, account, funderName, now);
    }

    /**
    * @dev Owners can add other owners to the diary
    *
    * @param account The account of the owner to add
    * @param ownerName The name of the owner to add
    */
    function addOwner(address account, string memory ownerName) public onlyOwners() {
        require(account != address(0), "cannot be 0x0 address");

        Owner memory newOwner;
        newOwner.account = account;
        newOwner.name = ownerName;

        owners[account] = newOwner;
        emit OwnerAdded(msg.sender, account, ownerName, now);
    }

    /**
    * @dev Funders can remove owners from the diary
    *
    * @param account The account of the owner to remove
    */
    function removeOwner(address account) public onlyFundersOrOwner() {
        require(account != address(0), "cannot be 0x0 address");
        require(isOwner(account), "Owner does not exist");
        
        Owner memory owner = owners[account];
        delete owners[account];
        emit OwnerRemoved(msg.sender, owner.account, owner.name, now);
    }

    /**
    * @dev Owners can add events to the diary. Event are immutable and cannot be deleted
    *
    * @param eventDescription Description of the event
    * @param location Location of the event
    */
    function addEvent(string memory eventDescription, string memory location) public onlyOwners() {
        Event memory newEvent;
        newEvent.date = now;
        newEvent.by = msg.sender;
        newEvent.description = eventDescription;
        newEvent.location = location;

        uint256 eventId = nbEvents++;

        events[eventId] = newEvent;
        emit EventAdded(msg.sender, eventId, now);
    }

    /**
    * @dev Get a specific event
    *
    * @param id Id of the event
    */
    function getEvent(uint256 id) public view returns (Event memory) {
        return events[id];
    }
}
