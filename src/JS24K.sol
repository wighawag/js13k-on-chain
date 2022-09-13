// SPDX-License-Identifier: AGPL-1.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract JS24K {
	using Strings for uint96;
	using Strings for uint256;
	using Strings for uint160;

	event Transfer(address indexed from, address indexed to, uint256 indexed id);

	mapping(uint256 => address) public ownerOf;

	// function mint(bytes calldata) external {
	// 	uint256 newContract;
	// 	assembly {
	// 		let len := calldataload(36)
	// 		if gt(len, 0xFFFF) {
	// 			revert(0, 0)
	// 		}
	// 		let p := mload(0x40)
	// 		// mstore(p, 0x0be77f56)
	// 		pop(staticcall(gas(), 0x000000000000000000636F6e736F6c652e6c6f67, p, 2, 0, 0))

	// 		// PUSH2 LENGTH LENGTH, PUSH 00, DUP2, PUSH 0B, DUP3, CODECOPY, RETURN
	// 		mstore(p, or(shl(232, len), 0x610000600081600B8239F3000000000000000000000000000000000000000000))
	// 		// mstore(p, 0x0be77f56)
	// 		pop(staticcall(gas(), 0x000000000000000000636F6e736F6c652e6c6f67, p, 32, 0, 0))
	// 		calldatacopy(add(p, 0x0B), 68, len)
	// 		// mstore(p, 0x0be77f56)
	// 		pop(staticcall(gas(), 0x000000000000000000636F6e736F6c652e6c6f67, p, add(len, 0x0B), 0, 0))

	// 		newContract := create(0, p, add(len, 0x0B))
	// 	}
	// 	ownerOf[newContract] = msg.sender;
	// 	emit Transfer(address(0), msg.sender, newContract);
	// }

	// SHOULD WORK
	// function mint(bytes calldata) external {
	// 	uint256 newContract;
	// 	assembly {
	// 		let len := calldataload(36)
	// 		if gt(len, 0x6000) {
	// 			revert(0, 0)
	// 		}
	// 		let p := mload(0x40)

	// 		// PUSH2 LENGTH LENGTH, PUSH 00, DUP2, PUSH1 0B, DUP3, CODECOPY, RETURN
	// 		// STACK: LENGTH LENGTH, 00, LENGTH LENGTH, 0B, 00
	// 		// mstore(p, or(shl(232, len), 0x610000600081600B8239F3000000000000000000000000000000000000000000))
	// 		mstore(p, 0x610070600081600B8239F3000000000000000000000000000000000000000000)
	// 		calldatacopy(add(p, 0x0B), 68, len)

	// 		newContract := create(0, p, add(len, 0x0B))
	// 	}
	// 	ownerOf[newContract] = msg.sender;
	// 	emit Transfer(address(0), msg.sender, newContract);
	// }

	// WORKING
	// function mint(bytes calldata) external {
	// 	uint256 newContract;
	// 	assembly {
	// 		let len := calldataload(36)
	// 		if gt(len, 0xFFFF) {
	// 			revert(0, 0)
	// 		}
	// 		let p := mload(0x40)
	// 		// PUSH2 LENGTH LENGTH, PUSH1 0E, PUSH1 00,CODECOPY
	// 		// STACK: LENGTH LENGTH, 0E, 00
	// 		// PUSH2 LENGTH LENGTH, PUSH1 00, RETURN
	// 		// STACK: LENGTH, LENGTH, 00
	// 		mstore(p, 0x61FFFF600E60003961FFFF6000F3000000000000000000000000000000000000)
	// 		let lenByte1 := shr(8, len)
	// 		let lenByte2 := and(len, 0xFF)
	// 		mstore8(add(p, 1), lenByte1)
	// 		mstore8(add(p, 2), lenByte2)
	// 		mstore8(add(p, 9), lenByte1)
	// 		mstore8(add(p, 10), lenByte2)
	// 		calldatacopy(add(p, 14), 68, len)

	// 		newContract := create(0, p, add(len, 14))
	// 		log2(p, add(len, 14), len, newContract) // need this line, no idea why, looks like some memory management issues
	// 	}
	// 	ownerOf[newContract] = msg.sender;
	// 	emit Transfer(address(0), msg.sender, newContract);
	// }

	// function mint(bytes calldata) external {
	// 	uint256 newContract;
	// 	assembly {
	// 		let len := calldataload(36)
	// 		if gt(len, 0xFFFF) {
	// 			revert(0, 0)
	// 		}
	// 		let p := mload(0x40)
	// 		// mstore(p, 0x615870600E6000396158706000F3000000000000000000000000000000000000)
	// 		mstore(p, 0x615870600081600B8239F3000000000000000000000000000000000000000000)
	// 		calldatacopy(add(p, 11), 68, len)

	// 		newContract := create(0, p, add(len, 11))
	// 		log2(p, add(len, 11), len, newContract) // need this line, no idea why, looks like some memory management issues
	// 	}
	// 	ownerOf[newContract] = msg.sender;
	// 	emit Transfer(address(0), msg.sender, newContract);
	// }

	// WORK WITH EXTRA LOG1 ????
	function mint(bytes calldata) external {
		console.logBytes(abi.encodeWithSignature("Error(string)", "too big"));
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
			log2(p, add(len, 11), len, newContract) // need this line, no idea why, looks like some memory management issues
		}
		ownerOf[newContract] = msg.sender;
		emit Transfer(address(0), msg.sender, newContract);
	}

	function contractURI(address receiver, uint96 per10Thousands) external pure returns (string memory) {
		return
			string(
				bytes.concat(
					'data:application/json,{"name":"JS24K","description":JS24K%20on-chain%20.","image":"data:image/svg+xml;base64,","external_link":"https://JS24Kgames.com","seller_fee_basis_points":',
					bytes(per10Thousands.toString()),
					',"fee_recipient":"',
					bytes(uint160(receiver).toHexString(20)),
					'"}'
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
					"<svg%2520viewBox='0%25200%252032%252016'xmlns='http://www.w3.org/2000/svg'><text%2520x='50%'y='50%'dominant-baseline='middle'text-anchor='middle'style='fill:rgb(219,39,119);font-size:12px;'>",
					bytes(gameName),
					"</text></svg>"
					'",',
					'"animation_url":"data:text/html;base64,',
					gameData,
					'"}'
				)
			);
	}
}
