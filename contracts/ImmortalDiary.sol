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

    struct Member {
        address account;
        string name;
    }

    /* --- Constants --- */
    string public name;
    string public description;
    uint256 public creationDate;

    /* --- Variables --- */
    uint256 public nbEvents;

    mapping (address => Member) private _funders;
    mapping (address => Member) private _members;
    mapping (uint256 => Event) private _events;

    /* --- Events --- */
    event FunderAdded(address indexed by, address indexed account, string name, uint256 date);
    event MemberAdded(address indexed by, address indexed account, string name, uint256 date);
    event MemberRemoved(address indexed by, address indexed account, string name, uint256 date);
    event EventAdded(address indexed by, uint256 eventId, uint256 date);

    /* --- Modifiers --- */

    /**
    * @dev Checks that account is a funder or the owner
    */
    modifier onlyFundersOrOwner() {
        require(isOwner() || isFunder(msg.sender), "Not a funder or owner");
        _;
    }

    /**
    * @dev Checks that account is a member or the owner (funders are among members)
    */
    modifier onlyMembersOrOwner() {
        require(isOwner() || isMember(msg.sender), "Not a member or owner");
        _;
    }

    /**
    * @dev Checks that account is a member (funders are among members)
    */
    modifier onlyMembers() {
        require(isMember(msg.sender), "Not a member");
        _;
    }

    /* --- Public functions --- */

    /**
     * @dev Creates a new immortal diary with a name and a description
     *
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
        return _funders[account].account != address(0);
    }

    /**
    * @dev Verifies that a given account is a member
    *
    * @param account The address to verify
    * @return true if account is a member, false otherwise
    */
    function isMember(address account) public view returns (bool) {
        return _members[account].account != address(0);
    }

    /**
    * @dev Owner of the diary can add fudners to it
    *
    * @param account The account of the funder to add
    * @param funderName The name of the funder to add
    */
    function addFunder(address account, string memory funderName) public onlyOwner() {
        require(account != address(0), "cannot be 0x0 address");
        require(!isFunder(account), "Account is already a funder");
        require(!stringIsEmpty(funderName), "Funder name cannot be empty");

        Member memory newFunder;
        newFunder.account = account;
        newFunder.name = funderName;

        _funders[account] = newFunder;
        _members[account] = newFunder;
        emit FunderAdded(msg.sender, account, funderName, now);
        emit MemberAdded(msg.sender, account, funderName, now);
    }

    /**
    * @dev Members (and the owner) can add other members to the diary
    *
    * @param account The account of the member to add
    * @param memberName The name of the member to add
    */
    function addMember(address account, string memory memberName) public onlyMembersOrOwner() {
        require(account != address(0), "cannot be 0x0 address");
        require(!isMember(account), "Account is already a member");
        require(!stringIsEmpty(memberName), "Member name cannot be empty");

        // Check that a funder with the same address does not exist
        Member memory funder = _funders[account];
        if(funder.account != address(0)) {
            _members[account] = funder;
        } else {
            Member memory newMember;
            newMember.account = account;
            newMember.name = memberName;
            _members[account] = newMember;
        }

        emit MemberAdded(msg.sender, account, memberName, now);
    }

    /**
    * @dev Funders (and the owner) can remove members from the diary
    *
    * @param account The account of the member to remove
    */
    function removeMember(address account) public onlyFundersOrOwner() {
        require(isMember(account), "Member does not exist");
        require(!isFunder(account), "Cannot remove a member that is a founder");
        
        Member memory member = _members[account];
        delete _members[account];
        emit MemberRemoved(msg.sender, member.account, member.name, now);
    }

    /**
    * @dev Members can add events to the diary. Event are immutable and cannot be deleted
    *
    * @param eventDescription Description of the event
    * @param location Location of the event
    */
    function addEvent(string memory eventDescription, string memory location) public onlyMembers() {
        require(!stringIsEmpty(eventDescription), "Event description cannot be empty");
        require(!stringIsEmpty(location), "Event location cannot be empty");

        Event memory newEvent;
        newEvent.date = now;
        newEvent.by = msg.sender;
        newEvent.description = eventDescription;
        newEvent.location = location;

        uint256 eventId = nbEvents++;

        _events[eventId] = newEvent;
        emit EventAdded(msg.sender, eventId, now);
    }

    /**
    * @dev Get a specific event
    *
    * @param id Id of the event
    */
    function getEvent(uint256 id) public view returns (Event memory) {
        return _events[id];
    }

    /**
    * @dev Get a specific funder
    *
    * @param account Address of the funder
    */
    function getFunder(address account) public view returns (Member memory) {
        return _funders[account];
    }

    /**
    * @dev Get a specific member
    *
    * @param account Address of the member
    */
    function getMember(address account) public view returns (Member memory) {
        return _members[account];
    }

    function stringIsEmpty(string memory str) private pure returns (bool) {
        return bytes(str).length == 0;
    }
}
