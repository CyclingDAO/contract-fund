const Fund = artifacts.require("Fund");

contract("Fund", ([owner, member1, member2, member3]) => {
    const member1Name = 'outprog'
    const member2Name = 'xiaopang'
    const member3Name = 'guo'
    const member1Km = 10
    const member2Km = 99
    const member2KmSub = 9
    const member3Km = 0
    const activityID = 201910

    it("should register memaber success", async () => {
        fund = await Fund.new();

        assert.equal(await fund.isMember(member1), false)

        await fund.registerMember(member1Name, member1)

        m = await fund.members(member1)
        assert.equal(member1Name, m.name)
        assert.equal(true, await fund.isMember(member1))

        // deregister member
        await fund.deregisterMember(member1)

        assert.equal(false, await fund.isMember(member1))
    });

    it("should start activity", async () => {
        fund = await Fund.new();

        assert.equal(await fund.activityStatus(), 0)

        await fund.startActivity(activityID, {
            value: web3.utils.toWei('0.1', 'ether'),
        })

        assert.equal(1, await fund.activityStatus())
        assert.equal(activityID, await fund.activityID())
        assert.equal(web3.utils.toWei('0.1', 'ether'), await fund.totalReward())
    });

    it("should add reward", async () => {
        fund = await Fund.new();
        await fund.startActivity(activityID)

        await fund.send(web3.utils.toWei('0.3', 'ether'))
        assert.equal(web3.utils.toWei('0.3', 'ether'), await fund.totalReward())
    });

    it("should update km", async () => {
        fund = await Fund.new();
        await fund.registerMember(member1Name, member1)
        await fund.registerMember(member2Name, member2)
        await fund.startActivity(activityID)

        m1 = await fund.members(member1)
        assert.equal(0, m1.updatedActivityID)
        assert.equal(0, m1.activityKm)

        await fund.addKm([member1, member2], [member1Km, member2Km])

        m1 = await fund.members(member1)
        assert.equal(activityID, m1.updatedActivityID)
        assert.equal(member1Km, m1.activityKm)

        m2 = await fund.members(member2)
        assert.equal(activityID, m2.updatedActivityID)
        assert.equal(member2Km, m2.activityKm)

        assert.equal(member1Km + member2Km, await fund.activityTotalKm())

        // sub km
        await fund.subKm([member2], [member2KmSub])

        m2 = await fund.members(member2)
        assert.equal(member2Km-member2KmSub, m2.activityKm)

        assert.equal(member1Km+member2Km-member2KmSub, await fund.activityTotalKm())
    });

    it("should to be claim status", async () => {
        fund = await Fund.new();
        await fund.startActivity(activityID)

        await fund.startClaim()
        assert.equal(2, await fund.activityStatus())
    });

    it("should claim success", async () => {
        fund = await Fund.new();
        await fund.registerMember(member1Name, member1)
        await fund.registerMember(member2Name, member2)
        await fund.registerMember(member3Name, member3)
        await fund.startActivity(activityID, {
            value: web3.utils.toWei('10', 'ether'),
        })
        await fund.addKm([member1, member2, member3], [member1Km, member2Km, member3Km])
        await fund.startClaim()

        await fund.claim({from: member1})
        await fund.claim({from: member2})
        await fund.claim({from: member3})

        // balanceOfMember1 = await web3.eth.getBalance(member1)
        // console.log("balanceOfMember1", balanceOfMember1)
        // balanceOfMember2 = await web3.eth.getBalance(member2)
        // console.log("balanceOfMember2", balanceOfMember2)
        // balanceOfMember3 = await web3.eth.getBalance(member3)
        // console.log("balanceOfMember3", balanceOfMember3)

        balanceOfFund = await web3.eth.getBalance(fund.address)
        assert.equal(1, balanceOfFund) // precision problem

        assert.equal(109, await fund.totalKm())
    });

    it("should end activity", async () => {
        fund = await Fund.new();
        await fund.startActivity(activityID, {
            value: web3.utils.toWei('1', 'ether'),
        })

        balanceOfFund = await web3.eth.getBalance(fund.address)
        assert.equal(web3.utils.toWei('1', 'ether'), balanceOfFund)

        await fund.endActivity()
        assert.equal(0, await fund.activityStatus())

        balanceOfFund = await web3.eth.getBalance(fund.address)
        assert.equal(0, balanceOfFund)

        assert.equal(0, await fund.activityTotalKm())
        assert.equal(0, await fund.totalReward())
        assert.equal(0, await fund.usedReward())
    });
})