pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./join.sol";
import "./SavingsDai.sol";
import "../lib/dss/src/vat.sol";
import "../lib/dss/src/pot.sol";

contract Hevm {
    function warp(uint256) public;
}

contract Usr {
    Pot public pot;
    // SavingsDai public sDai;
    constructor(Pot pot_) public {
        pot = pot_;
        // sDai = sDai_;
        // join = join_;
    }

    function hope(address usr) public {
        pot.hope(usr);
    }
    function nope(address usr) public {
        pot.nope(usr);
    }
    function join(address join_, address usr, uint wad) public {
        sDaiJoin(join_).join(usr, wad);
    }
}

contract SavingsDaiTest is DSTest {
    Hevm hevm;

    SavingsDai sDai;
    Vat vat;
    Pot pot;
    sDaiJoin join;

    address vow;
    address self;

    function rad(uint wad_) internal pure returns (uint) {
        return wad_ * 10 ** 27;
    }
    function wad(uint rad_) internal pure returns (uint) {
        return rad_ / 10 ** 27;
    }

    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        hevm.warp(604411200);

        self = address(this);

        setupDss();

        sDai = createToken();
        join = new sDaiJoin(address(pot), address(sDai));
        sDai.rely(address(join));
    }

    function setupDss() internal {
        vat = new Vat();
        pot = new Pot(address(vat));
        vat.rely(address(pot));

        vow = address(bytes20("vow"));
        pot.file("vow", vow);

        vat.suck(self, self, rad(100 ether));
        vat.hope(address(pot));
    }

    function createToken() internal returns (SavingsDai) {
        return new SavingsDai(99);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_deploy() public {
        assertEq(address(pot.vat()), address(vat));
        assertEq(address(join.pot()), address(pot));
        assertEq(address(join.sDai()), address(sDai));
    }

    function test_join_sDai_0d() public {
        Usr ali = new Usr(pot);
        pot.join(100 ether);
        pot.move(address(this), address(ali), 100 ether);
        assertEq(pot.pie(address(this)), 0 ether);
        assertEq(pot.pie(address(ali)), 100 ether);
        ali.hope(address(join));
        ali.join(address(join), address(ali), 100 ether);
        assertEq(sDai.balanceOf(address(ali)), 100 ether);
    }
}
