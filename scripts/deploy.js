const { ethers } = require("hardhat");

async function main() {
    const GhostApeVault = await ethers.getContractFactory("GhostApeVault");
    const ghostApeVault = await GhostApeVault.deploy();
    await ghostApeVault.deployed();
    // const ghostApeVault = await GhostApeVault.attach("0x8a3055a39d54aebDfA6Fc30beF606757915c9F4C");
    console.log("GhostApeVault address:", ghostApeVault.address);

    const GhostApe = await ethers.getContractFactory("GhostApe");
    const ghostApe = await GhostApe.deploy(ghostApeVault.address);
    await ghostApe.deployed();
    // const ghostApe = await GhostApe.attach("0xbDdb677A7Dbb790c3808520E33f794CCFB7D8a85");
    console.log("GhostApe address:", ghostApe.address);

    await ghostApe.setBaseURI("ipfs://bafybeickp46wkwpxqki2j4wbhumhmurq7jbg4jf5re3mob7sq3obydeeoy/");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
