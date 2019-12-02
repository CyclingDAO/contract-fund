const Membership = artifacts.require("Membership");

const { expectRevert } = require('@openzeppelin/test-helpers');

contract("Membership", ([owner, member1, dao]) => {
  const member1Name = 'outprog'

  it("should generate a membership", async () => {
    const membership1 = await Membership.new(dao, member1, member1Name)

    let mName = await membership1.name()
    assert.equal(mName, member1Name)
    let mOwner = await membership1.owner()
    assert.equal(mOwner, member1)
    let mDao = await membership1.cyclingDAO()
    assert.equal(mDao, dao)
  })

  it("should set total", async () => {
    const membership1 = await Membership.new(dao, member1, member1Name)

    await expectRevert(
      membership1.setTotal(123, {from: member1}),
      'caller is not cycling dao',
    )

    await membership1.setTotal(123, {from: dao})
    let mTotal = await membership1.totalKm()
    assert.equal(mTotal, 123)
  })

  it("should set activity", async () => {
    const membership1 = await Membership.new(dao, member1, member1Name)

    await expectRevert(
      membership1.setActivity(20190101, 100, {from: member1}),
      'caller is not cycling dao',
    )

    await membership1.setActivity(20190101, 100, {from: dao})
    let mCurrentActivityID = await membership1.currentActivityID()
    assert.equal(mCurrentActivityID, 20190101)
    let mCurrentActivityKm = await membership1.currentActivityKm()
    assert.equal(mCurrentActivityKm, 100)
    let mCurrentActivityIsClaimed = await membership1.currentActivityIsClaimed()
    assert.equal(mCurrentActivityIsClaimed, false)
  })

  it("should claimed", async () => {
    const membership1 = await Membership.new(dao, member1, member1Name)

    await expectRevert(
      membership1.setActivity(20190101, 100, {from: member1}),
      'caller is not cycling dao',
    )

    await membership1.setActivity(20190101, 100, {from: dao})

    await expectRevert(
      membership1.toClaimed({from: member1}),
      'caller is not cycling dao',
    )

    await membership1.toClaimed({from: dao})
    let mTotal = await membership1.totalKm()
    assert.equal(mTotal, 100)
    let mCurrentActivityID = await membership1.currentActivityID()
    assert.equal(mCurrentActivityID, 0)
    let mCurrentActivityKm = await membership1.currentActivityKm()
    assert.equal(mCurrentActivityKm, 0)
    let mCurrentActivityIsClaimed = await membership1.currentActivityIsClaimed()
    assert.equal(mCurrentActivityIsClaimed, true)
  })
})