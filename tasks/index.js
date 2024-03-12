// set the Oracle address for the OmniCounter

//
task(
    "setTrustedRemote",
    "setTrustedRemote(chainId, sourceAddr) to enable inbound/outbound messages with your other contracts",
    require("./setTrustedRemote")
)
    .addParam("targetNetwork", "the target network to set as a trusted remote")
    .addOptionalParam("localContract", "Name of local contract if the names are different")
    .addOptionalParam("remoteContract", "Name of remote contract if the names are different")
    .addOptionalParam("contract", "If both contracts are the same name")

//
task("setCustomAdapterParams", "enable custom adapter params", require("./setCustomAdapterParams")).addParam("contract", "contract name")

//
task("approveNFT", "approve Omnichain proxy to transfer your ERC721/1155 tokens", require("./approveNFT"))
    .addOptionalParam("contract", "the name of the OFT contract, e.g. 'ProxyONFT'", "")
    .addOptionalParam("address", "address of the token you want to approve (leave empty to use tokenConfig values)", "")
    .addOptionalParam("spender", "address that should get an allowance (overrides `contract`)", "")

//
task("sendONFT1155", "send an ONFT nftId from one chain to another", require("./sendONFT1155"))
    .addParam("tokenId", "the tokenId of ONFT")
    .addParam("targetNetwork", "the chainId to transfer to")
    .addParam("contract", "ONFT contract name")
    .addOptionalParam("amount", "number of tokens", 1, types.int)

//
task("setMinDstGas", "set min gas required on the destination gas", require("./setMinDstGas"))
    .addParam("packetType", "message Packet type")
    .addParam("targetNetwork", "the chainId to transfer to")
    .addParam("contract", "contract name")
    .addParam("minGas", "min gas")

task("setupONFT1155", "go through all steps of the base ONFT setup", require("./setupONFT1155"))
    .addParam("localContract", "name of contract on source chain")
    .addParam("remoteContract", "name of contract on destination chain")
    .addParam("targetNetwork", "destination network")
    .addOptionalParam("minGas", "gas config", "")