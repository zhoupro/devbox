require  'busted.runner'()
package.path = package.path .. ';./*.lua'

describe("test", function()
    it("should be easy to user", function()
        assert.are.same(5,5)
    end)
end)