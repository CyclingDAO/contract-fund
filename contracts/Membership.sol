pragma solidity ^0.5.0;

import "./CyclingData.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Membership is
  Ownable,
  CyclingData(address(0))
{
  string public name;

  event SetName(address owner, string name);

  constructor(address _dao, address _owner, string memory _name) public {
    cyclingDAO = _dao;
    name = _name;
    _transferOwnership(_owner);
  }

  function setName(string memory _name) public onlyOwner {
    name = _name;
    emit SetName(msg.sender, _name);
  }
}