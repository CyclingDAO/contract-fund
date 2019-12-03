pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./IMembership.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @notice Fund for Cycling Activity reward
 */
contract Fund is
    Ownable
{
  /**
   * @notice Reigster membership
  */
  mapping(address=>bool) public isMember;

  /**
   * @notice Default Activity is End
  */
  enum ActivityStatus {
    END,
    START,
    CLAIM
  }

  uint256 public totalKm;
  uint256 public activityID;
  uint256 public activityTotalKm;
  ActivityStatus public activityStatus;

  mapping(uint256=>bool) private isUsedActivityID;

  /**
   * @notice Reward records
  */
  uint256 public totalReward;
  uint256 public usedReward;

  /**
   * @notice Events
  */
  event RegisterMember(address membership);
  event DeregisterMember(address membership);
  event TransferDAO(address membership, address previousDAO, address newDAO);
  event StartActivity(uint256 id, uint256 reward);
  event AdditionalReward(uint256 id, uint256 addReward);
  event AddKm(uint256 id, address member, uint256 addKm);
  event SubKm(uint256 id, address member, uint256 subKm);
  event StartClaim();
  event Claim(uint256 id, address member, uint256 activityKm, uint256 reward);
  event EndActivity(uint256 surplus);

  /**
   * @notice Membership management
  */
  function registerMembers(address[] memory _members) public onlyOwner {
    for(uint i = 0; i < _members.length; i++) {
      require(
        !isMember[_members[i]],
        "MEMBER_REGISTERED"
      );

      isMember[_members[i]] = true;

      emit RegisterMember(_members[i]);
    }
  }

  function deregisterMembers(address[] memory _members) public onlyOwner {
    for(uint i = 0; i < _members.length; i++) {
      isMember[_members[i]] = false;

      emit DeregisterMember(_members[i]);
    }
  }

  function transferDAO(address[] memory _members, address _newDAO) public onlyOwner {
    for(uint i = 0; i < _members.length; i++) {
      require(
        isMember[_members[i]],
        "NOT_MEMBER"
      );

      IMembership(_members[i]).transferCyclingDAO(_newDAO);

      emit TransferDAO(_members[i], address(this), _newDAO);
    }
  }

  /**
   * @notice Activity flow:
    start(owner) ->  update Km(owner, add or sub) -> startClaim(owner)
    -> claim(member) -> end(owner)
  */
  function startActivity(uint256 _id) public payable onlyOwner {
    require(
      activityStatus == ActivityStatus.END,
      "ACTIVITY_NOT_END"
    );

    require(
      !isUsedActivityID[_id],
      "USED_ACTIVITYID"
    );

    activityID = _id;
    activityStatus = ActivityStatus.START;

    totalReward = msg.value;

    isUsedActivityID[activityID] = true;

    emit StartActivity(activityID, totalReward);
  }

  /**
   * @notice Send more ETH to Fund Conctact be activity reward
   */
  function() external payable{
    require(
      activityStatus == ActivityStatus.START,
      "ACTIVITY_NOT_START"
    );

    totalReward = SafeMath.add(totalReward, msg.value);

    emit AdditionalReward(activityID, msg.value);
  }

  // TODO: use oracle
  // function setActivity(address[] memory _members, uint256[] memory _kms) public onlyOwner{
  //   require(
  //     activityStatus == ActivityStatus.START,
  //     "ACTIVITY_NOT_START"
  //   );

  //   require(
  //     _members.length == _kms.length,
  //     "UPDATEKM_LENGTH_NOT_EQUAL"
  //   );

  //   for(uint i = 0; i < _members.length; i++) {
  //     require(
  //       isMember[_members[i]],
  //       "NOT_MEMBER"
  //     );

  //     if(members[_members[i]].updatedActivityID != activityID) {
  //       members[_members[i]].activityKm = 0;
  //       members[_members[i]].updatedActivityID = activityID;
  //       members[_members[i]].isClaimed = false;
  //     }

  //     members[_members[i]].activityKm = SafeMath.add(
  //       members[_members[i]].activityKm,
  //       _kms[i]);

  //     activityTotalKm = SafeMath.add(activityTotalKm, _kms[i]);

  //     emit AddKm(activityID, _members[i], _kms[i]);
  //   }
  // }

  // function subKm(address[] memory _members, uint256[] memory _kms) public onlyOwner{
  //   require(
  //     activityStatus == ActivityStatus.START,
  //     "ACTIVITY_NOT_START"
  //   );

  //   require(
  //     _members.length == _kms.length,
  //     "UPDATEKM_LENGTH_NOT_EQUAL"
  //   );

  //   for(uint i = 0; i < _members.length; i++) {
  //     require(
  //       isMember[_members[i]],
  //       "NOT_MEMBER"
  //     );

  //     require(
  //       members[_members[i]].updatedActivityID == activityID,
  //       "NO_KM_UPDATE"
  //     );

  //     require(
  //       members[_members[i]].activityKm > _kms[i],
  //       "KM_MORE_THEN_ACTIVITYKM"
  //     );

  //     members[_members[i]].activityKm = SafeMath.sub(
  //       members[_members[i]].activityKm,
  //       _kms[i]);

  //     activityTotalKm = SafeMath.sub(activityTotalKm, _kms[i]);

  //     emit SubKm(activityID, _members[i], _kms[i]);
  //   }
  // }

  function startClaim() public onlyOwner {
    require(
      activityStatus == ActivityStatus.START,
      "ACTIVITY_NOT_START"
    );

    activityStatus = ActivityStatus.CLAIM;

    emit StartClaim();
  }

  // function claim() public {
  //   require(
  //     activityStatus == ActivityStatus.CLAIM,
  //     "ACTIVITY_NOT_CLAIM"
  //   );

  //   require(
  //     members[msg.sender].updatedActivityID == activityID,
  //     "ACTIVITYID_NOT_EQUAL"
  //   );

  //   require(
  //     !members[msg.sender].isClaimed,
  //     "IS_CLAIMED"
  //   );

  //   members[msg.sender].isClaimed = true;
  //   members[msg.sender].usedKm = SafeMath.add(
  //     members[msg.sender].usedKm,
  //     members[msg.sender].activityKm
  //   );
  //   totalKm = SafeMath.add(totalKm, members[msg.sender].activityKm);

  //   uint256 value = SafeMath.div(
  //     SafeMath.mul(
  //       totalReward,
  //       members[msg.sender].activityKm),
  //     activityTotalKm
  //   );

  //   usedReward = SafeMath.add(usedReward, value);
  //   msg.sender.transfer(value);

  //   emit Claim(activityID, msg.sender, members[msg.sender].activityKm, value);
  // }

  /**
   * @notice endActivity whatever activity status
   */
  function endActivity() public onlyOwner {
    activityStatus = ActivityStatus.END;

    activityID = 0;
    activityTotalKm = 0;
    totalReward = 0;
    usedReward = 0;

    uint256 value = address(this).balance;
    msg.sender.transfer(value);

    emit EndActivity(value);
  }
}