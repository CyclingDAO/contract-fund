pragma solidity ^0.5.0;

interface IMembership {
  function owner() external view returns (address);
  function transferCyclingDAO(address _newDAO) external;

  function currentActivityID() external view returns(uint256);
  function currentActivityKm() external view returns(uint256);
  function currentActivityIsClaimed() external view returns(bool);

  function setTotal(uint256 _totalKm) external;
  function setActivity(uint256 _id, uint256 _km) external returns(uint256 sign, uint256 value);
  function toClaimed() external;
}