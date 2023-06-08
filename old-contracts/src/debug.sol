// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract debug {
	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);

	function sendLog(bytes memory pointer, uint256 length) internal view {
		address consoleAddress = CONSOLE_ADDRESS;
		assembly {
			let r := staticcall(gas(), consoleAddress, pointer, length, 0, 0)
		}
	}
}
