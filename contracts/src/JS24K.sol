// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

import "solidity-kit/solc_0.8/ERC721/interfaces/IERC721Metadata.sol";
import "solidity-kit/solc_0.8/ERC173/interfaces/IERC173.sol";
import "solidity-kit/solc_0.8/ERC721/TokenURI/interfaces/IContractURI.sol";

import "solidity-kit/solc_0.8/ERC721/implementations/BasicERC721.sol";
import "solidity-kit/solc_0.8/ERC721/ERC4494/implementations/UsingERC4494PermitWithDynamicChainID.sol";
import "solidity-kit/solc_0.8/ERC173/implementations/Owned.sol";

/// @notice Js24K NFT Collection
/// @title JS24K
contract JS24K is BasicERC721, UsingERC4494PermitWithDynamicChainID, IERC721Metadata, IContractURI, Owned {
	using Strings for uint96;
	using Strings for uint256;
	using Strings for uint160;

	// ------------------------------------------------------------------------------------------------------------------
	// CONSTRUCTOR
	// ------------------------------------------------------------------------------------------------------------------

	constructor(address contractOwner)
		UsingERC712WithDynamicChainID(address(0))
		Owned(contractOwner, 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e) // ENS Registry
	{}

	// ------------------------------------------------------------------------------------------------------------------
	// EXTERNAL INTERFACE
	// ------------------------------------------------------------------------------------------------------------------

	/// @inheritdoc IERC721Metadata
	function name() public pure override(IERC721Metadata, Named) returns (string memory) {
		return "Blockies";
	}

	/// @inheritdoc IERC721Metadata
	function symbol() external pure returns (string memory) {
		return "BLOCKY";
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 interfaceID)
		public
		view
		override(BasicERC721, UsingERC4494Permit, IERC165)
		returns (bool)
	{
		return BasicERC721.supportsInterface(interfaceID) || UsingERC4494Permit.supportsInterface(interfaceID);
	}

	function mint(bytes calldata) external {
		uint256 newContract;
		assembly {
			let len := calldataload(36)
			if gt(len, 0x6000) {
				mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
				mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
				mstore(64, 0x00000007746f6f20626967000000000000000000000000000000000000000000)
				revert(0, 75)
			}
			let p := mload(0x40)

			// PUSH2 LENGTH LENGTH, PUSH 00, DUP2, PUSH1 0B, DUP3, CODECOPY, RETURN
			// STACK: LENGTH LENGTH, 00, LENGTH LENGTH, 0B, 00
			mstore(p, or(shl(232, len), 0x610000600081600B8239F3000000000000000000000000000000000000000000))
			calldatacopy(add(p, 0x0B), 68, len)

			newContract := create(0, p, add(len, 0x0B))
		}
		require(newContract != 0, "CREATE_FAILS");
		_safeMint(msg.sender, newContract);
	}

	function contractURI() external pure returns (string memory) {
		return
			string(
				bytes.concat(
					// TODO
					'data:application/json,{"name":"JS24K","description":JS24K%20on-chain%20.","image":"data:image/svg+xml;base64,TODO","external_link":"https://JS24Kgames.com"}'
				)
			);
	}

	function at(address _addr) public view returns (bytes memory o_code) {
		assembly {
			// retrieve the size of the code, this needs assembly
			let size := extcodesize(_addr)
			// allocate output byte array - this could also be done without assembly
			// by using o_code = new bytes(size)
			o_code := mload(0x40)
			// new "memory end" including padding
			mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
			// store length in memory
			mstore(o_code, size)
			// actually retrieve the code, this needs assembly
			extcodecopy(_addr, add(o_code, 0x20), 0, size)
		}
	}

	function tokenURI(uint256 id) external view returns (string memory) {
		bytes memory gameData = at(address(uint160(id)));

		string memory gameName = "Triska";
		string memory gameId = "triska";
		return
			string(
				bytes.concat(
					'data:application/json,{"name":"',
					bytes(gameName),
					'","description":"A%20Game","external_url":"',
					"https://JS24Kgames.com/entries/",
					bytes(gameId),
					'","image":"',
					"data:image/svg+xml,<svg%2520viewBox='0%25200%252032%252016'xmlns='http://www.w3.org/2000/svg'><text%2520x='50%'y='50%'dominant-baseline='middle'text-anchor='middle'style='fill:rgb(219,39,119);font-size:12px;'>",
					bytes(gameName),
					"</text></svg>"
					'",',
					'"animation_url":"data:text/html;base64,',
					bytes(Base64.encode(gameData)),
					'"}'
				)
			);
	}
}
