import hre from "hardhat";

async function main() {
    const { ethers } = await hre.network.connect();

    const Switch = await ethers.getContractFactory("DeadManSwitch");

    const sw = await Switch.deploy();

    await sw.waitForDeployment();

    console.log("Deployed to:", await sw.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});