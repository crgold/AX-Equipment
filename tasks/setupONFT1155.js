const setTrustedRemote = require("./setTrustedRemote")
const setMinDstGas = require("./setMinDstGas")
const TOKEN_CONFIG = require("../constants/tokenConfig")

module.exports = async function ({ localContract, remoteContract, targetNetwork, minGas: minDstGas }, hre) {
    let minGas = minDstGas

    if (!minGas) {
        if (TOKEN_CONFIG[targetNetwork] && TOKEN_CONFIG[targetNetwork][remoteContract] && TOKEN_CONFIG[targetNetwork][remoteContract].minGas) {
            minGas = TOKEN_CONFIG[targetNetwork][remoteContract].minGas
        } else {
            minGas = targetNetwork.startsWith("beam") ? 10000000 : 100000
        }
    }

    console.log("\nsetting trusted remote...\n")
    await setTrustedRemote(
        {
            localContract,
            remoteContract,
            targetNetwork,
        },
        hre
    )

    console.log(`\nsetting min gas to ${minGas}...\n`)
    await setMinDstGas(
        {
            contract: localContract,
            packetType: 0,
            targetNetwork,
            minGas,
        },
        hre
    )

    await setMinDstGas(
        {
            contract: localContract,
            packetType: 1,
            targetNetwork,
            minGas,
        },
        hre
    )

    console.log("\nsetting custom adapter params...\n")
    const contract = await ethers.getContract(localContract)

    const tx = await contract.setUseCustomAdapterParams(true)

    console.log(`[${hre.network.name}] setUseCustomAdapterParams tx hash ${tx.hash}`)
    await tx.wait()
}