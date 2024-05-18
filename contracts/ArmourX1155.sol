// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "./ONFT1155.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract AX1155 is Ownable, ERC1155, ERC1155Burnable, ERC2981, ONFT1155 {
    uint256 private mintCount = 0;
    uint256 public constant MAX_SUPPLY = 3000;
    string public name = "ArmourX: Survivors";
    string public symbol = "AXS";

    /********************************************
     *** Constructor
     ********************************************/

    constructor(
        string memory _uri,
        uint96 _royaltyBasePoints,
        address _lzEndpoint
    ) ONFT1155(_uri, _lzEndpoint) {
        _setDefaultRoyalty(_msgSender(), _royaltyBasePoints);
    }

    /********************************************
     *** Public functions
     ********************************************/

    /**
     * @dev Convenience function for initial minting of the collection.
     */
    function batchMint(address _to, uint256 amount) external onlyOwner {
        require(mintCount < MAX_SUPPLY, "Collection is fully minted");
        unchecked {
            for (uint256 i = 0; i < amount && mintCount < MAX_SUPPLY; (i++, mintCount++)) {
                _mint(_to, mintCount, 1, "");
            }
        }
    }

    /**
     * @dev Standard mint function.
     */
    function mint(address _to, uint256 tokenId) external onlyOwner {
         _mint(_to, tokenId, 1, "");
    }

    /**
     * @dev Sets a new token metadata URI.
     */
    function setURI(string memory _uri) external virtual onlyOwner {
        _setURI(_uri);
    }

    /**
     * @dev Sets the royalty information that all ids in this contract will default to.
     */
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external virtual onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    /**
     * @dev Sets the royalty information for a specific token id, overriding the global default.
     */
    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external virtual onlyOwner {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    /**
     * @dev Transfer to multiple recipients.
     */
    function multiTransferFrom(address from, address[] memory tos, uint256 id, uint256 amount, bytes memory data) public virtual {
        require(from == _msgSender() || isApprovedForAll(from, _msgSender()), "ExtendedONFT1155: caller is not token owner or approved");

        for (uint256 i = 0; i < tos.length; ++i) {
            _safeTransferFrom(from, tos[i], id, amount, data);
        }
    }

    /**
     * @dev Batch transfer to multiple recipients.
     */
    function multiBatchTransferFrom(
        address from,
        address[] memory tos,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual {
        require(from == _msgSender() || isApprovedForAll(from, _msgSender()), "ExtendedONFT1155: caller is not token owner or approved");

        for (uint256 i = 0; i < tos.length; ++i) {
            _safeBatchTransferFrom(from, tos[i], ids, amounts, data);
        }
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}. Includes check for token existence.
     */
    function uri(uint256 id) public view virtual override returns (string memory) {
        require(id < MAX_SUPPLY, "ExtendedONFT1155: Token ID doesn't exist");

        // return the baseURI
        return string(
            abi.encodePacked(
                super.uri(id),
                Strings.toString(id)
            )
        );
    }

    /**
     * @dev Function for withdrawing erronously sent NFTs.
     */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    /**
     * @dev Function for withdrawing erronously sent tokens.
     */
    function withdrawTokens(IERC20 token) public onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.transfer(msg.sender, balance);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981, ONFT1155) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /********************************************
     *** Internal functions
     ********************************************/

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint[48] private __gap;
}