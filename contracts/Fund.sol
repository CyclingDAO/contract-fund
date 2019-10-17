pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

// Fund for Cycling Activity reward
contract Fund is 
    Ownable
{
    /////////////////////////
    // Member Variable
    /*
        name:               member name or nickname
        usedKm:             when member claim, usedKm add activityKm
        activityKm:         activityKm for claim, just valid current activity
        updatedActivityID:  last km updated activityID

        * if no claim and activity over, activityKm invalid
    */
    struct Member {
        string name;
        uint256 usedKm;
        uint256 activityKm;
        uint256 updatedActivityID;
    }

    mapping(address=>Member) public members;
    mapping(address=>bool) public isMember;
    // End of Member Variable
    /////////////////////////

    /////////////////////////
    // Activity Variable
    enum ActivityStatus {
        END,    // default Activity End
        START,
        CLAIM
    }

    uint256 public activityID;
    uint256 public activityTotalKm;
    ActivityStatus public activityStatus;
    // End of Activity Variable
    /////////////////////////

    /////////////////////////
    // Reward Variable
    uint256 public totalReward;
    uint256 public usedReward;
    // End of Variable
    /////////////////////////

    /////////////////////////
    // Events
    // TODO
    // End of Events
    /////////////////////////

    /////////////////////////
    // Member Manage 
    function registerMember(string memory _name, address _memberAddr) public onlyOwner {
        members[_memberAddr] = Member({
            name: _name,
            usedKm: 0,
            activityKm: 0,
            updatedActivityID: 0});
        isMember[_memberAddr] = true;
    }

    function deregisterMember(address _memberAddr) public onlyOwner {
        isMember[_memberAddr] = false;
    }
    // End of Member Manage
    /////////////////////////


    /////////////////////////
    // Organize Activity
    /* activity flow:
        start(owner) ->  update Km(owner, add or sub) -> startClaim(owner)
        -> claim(member) -> end(owner)
    */
    function startActivity(uint256 _id) payable public onlyOwner {
        require(
            activityStatus == ActivityStatus.END,
            "ACTIVITY_NOT_END"
        );

        activityID = _id;
        activityTotalKm = 0;
        activityStatus = ActivityStatus.START;

        totalReward = msg.value;
        usedReward = 0;
    }

    // Send more ETH to Fund Conctact be activity reward
    function() external payable{
        require(
            activityStatus == ActivityStatus.START,
            "ACTIVITY_NOT_START"
        );

        totalReward = SafeMath.add(totalReward, msg.value);
    }

    function addKm(address[] memory _members, uint256[] memory _kms) public onlyOwner{
        require(
            activityStatus == ActivityStatus.START,
            "ACTIVITY_NOT_START"
        );

        require(
            _members.length == _kms.length,
            "UPDATEKM_LENGTH_NOT_EQUAL"
        );

        for(uint i = 0; i < _members.length; i++) {
            require(
                isMember[_members[i]],
                "NOT_MEMBER"
            );

            members[_members[i]].activityKm = SafeMath.add(
                members[_members[i]].activityKm,
                _kms[i]); 
 
            members[_members[i]].updatedActivityID = activityID;

            activityTotalKm = SafeMath.add(activityTotalKm, _kms[i]);
        }
    }

    function subKm(address[] memory _members, uint256[] memory _kms) public onlyOwner{
        require(
            activityStatus == ActivityStatus.START,
            "ACTIVITY_NOT_START"
        );

        require(
            _members.length == _kms.length,
            "UPDATEKM_LENGTH_NOT_EQUAL"
        );

        for(uint i = 0; i < _members.length; i++) {
            require(
                isMember[_members[i]],
                "NOT_MEMBER"
            );

            require(
                members[_members[i]].activityKm > _kms[i],
                "KM_MORE_THEN_ACTIVITYKM"
            );

            members[_members[i]].activityKm = SafeMath.sub(
                members[_members[i]].activityKm,
                _kms[i]);

            members[_members[i]].updatedActivityID = activityID;

            activityTotalKm = SafeMath.sub(activityTotalKm, _kms[i]);
        }
    }

    function startClaim() public onlyOwner {
        require(
            activityStatus == ActivityStatus.START,
            "ACTIVITY_NOT_START"
        );

        activityStatus = ActivityStatus.CLAIM;
    }

    function claim() public {
        require(
            activityStatus == ActivityStatus.CLAIM,
            "ACTIVITY_NOT_CLAIM"
        );

        require(
            isMember[msg.sender],
            "NOT_MEMBER"
        );

        require(
            members[msg.sender].updatedActivityID == activityID,
            "ACTIVITYID_NOT_EQUAL"
        );

        uint256 value = SafeMath.div(
            SafeMath.mul(
                totalReward,
                members[msg.sender].activityKm),
            activityTotalKm
        );

        members[msg.sender].usedKm = SafeMath.add(
            members[msg.sender].usedKm,
            members[msg.sender].activityKm
        );
        members[msg.sender].activityKm = 0;

        usedReward = SafeMath.add(usedReward, value);
        msg.sender.transfer(value);
    }

    function endActivity() public onlyOwner {
        activityStatus = ActivityStatus.END;
        msg.sender.transfer(address(this).balance);
    }
    // End of Organize Activity
    /////////////////////////
}