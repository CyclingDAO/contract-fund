pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract CyclingData {
  address public cyclingDAO;

  uint256 public totalKm;

  uint256 public currentActivityID;
  uint256 public currentActivityKm;
  bool public currentActivityIsClaimed;

  constructor (address _dao) internal {
    cyclingDAO = _dao;
  }

  modifier onlyDAO() {
    require(cyclingDAO == msg.sender, "caller is not cycling dao");
    _;
  }

  // for data migrate
  function setTotal(uint256 _totalKm) external onlyDAO {
    totalKm = _totalKm;
  }

  function setActivity (uint256 _id, uint256 _km) external onlyDAO returns (uint256 sign, uint256 value) {
    sign = 1;
    value = 0;

    if(currentActivityID != _id) {
      currentActivityID = _id;
      currentActivityKm = _km;
      currentActivityIsClaimed = false;

      value = _km;
      return (sign, value);
    }

    if(currentActivityKm < _km) {
      value = SafeMath.sub(_km, currentActivityKm);
      currentActivityKm = _km;
      return (sign, value);
    }

    sign = 0;
    value = SafeMath.sub(currentActivityKm, _km);
    currentActivityKm = _km;
    return (sign, currentActivityKm);
  }

  function toClaimed () external onlyDAO {
    totalKm = SafeMath.add(totalKm, currentActivityKm);

    currentActivityID = 0;
    currentActivityKm = 0;
    currentActivityIsClaimed = true;
  }

  function transferCyclingDAO(address _newDAO) external onlyDAO {
    require(_newDAO != address(0), "new dao is the zero address");
    cyclingDAO = _newDAO;
  }
}