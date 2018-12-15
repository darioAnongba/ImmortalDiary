pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable";

contract ImmortalDiary is Ownable {    

    /* --- Structures --- */
    struct Event {
        string description;
        uint256 date;
        string location;
        string by;
    }

    struct Owner {
        address account;
        string name;
    }

    /* --- Constants --- */
    string public constant name;
    uint256 public constant creationDate;
    string public constant description;

    /* --- Variables --- */
    mapping (address => Owner) public funders;
    mapping (address => Owner) public owners;

    /* --- Events --- */
    event FunderAdded(address indexed by, address indexed funder, string name, uint256 date);
    event FunderRemoved(address indexed by, address indexed funder, string name, uint256 date);
    event OwnerAdded(address indexed by, address indexed owner, string name, uint256 date);
    event OwnerRemoved(address indexed by, address indexed owner, string name, uint256 date);
    event EventAdded(address indexed by, address indexed from, uint256 eventId, uint256 date);

    /* --- Modifiers --- */

    /**
    * @dev Checks that account is a funder
    *
    * @param account account to check
    */
    modifier onlyFundersOrOwner() {
        require(isOwner() || isFunder(msg.sender), "Not a funder");
        _;
    }

    /**
    * @dev Checks that account is an owner (funders are among owners)
    *
    * @param account account to check
    */
    modifier onlyOwners() {
        require(isOwner() || isOwner(msg.sender), "Not an owner");
        _;
    }

    /* --- Public functions --- */

    constructor(string name, string description) public {
        this.name = name;
        this.description = description;
        this.creationDate = now();
    }

    /**
    * @dev Verifies that a given account is a funder
    *
    * @param account The address to verify
    * @return true if account is a funder, false otherwise
    */
    function isFunder(address account) public view returns (bool) {
        return funders[account] != 0x0;
    }

    /**
    * @dev Verifies that a given account is an owner
    *
    * @param account The address to verify
    * @return true if account is an owner, false otherwise
    */
    function isOwner(address account) public view returns (bool) {
        return super.isOwner() || owners[account] != 0x0;
    }

    /**
    * @dev Owner of the diary can add fudners to it
    *
    * @param account The account of the funder to add
    * @param name The name of the funder to add
    */
    function addFunder(address account, string name) public onlyOwner() {
        newFunder storage newFunder;
        newFunder.account = account;
        newFunder.name = name;

        funders[account] = newFunder;
        owners[account] = newFunder;
        emit FunderAdded(msg.sender, account, name, now());
    }

    /**
    * @dev Owners can add other owners to the diary
    *
    * @param account The account of the owner to add
    * @param name The name of the owner to add
    */
    function addOwner(address account, string name) public onlyOwners() {
        Owner storage newOwner;
        newOwner.account = account;
        newOwner.name = name;

        owners[account] = newOwner;
        emit OwnerAdded(msg.sender, account, name, now());
    }

    /**
    * @dev Funders can remove owners from the diary
    *
    * @param account The account of the owner to remove
    */
    function removeOwner(address account) public onlyFundersOrOwner() {
        Owner memory owner = owners[account];
        require(owner != 0x0, "Owner does not exist");

        owners[account] = 0x0;
        emit OwnerRemoved(msg.sender, owner.account, owner.nam, now());
    }
}
