// Triska game was minified using https://jsminify.org/ and an html minifier and css minifier
// encode to uri : https://base64.guru/converter/encode/html
import {ethers} from 'hardhat';
import triska from '../games/triska.json';
import {JS24K} from '../typechain';

function toHex(str: string) {
	const res = [];
	const len = str.length;
	for (let n = 0, l = len; n < l; n++) {
		const hex = Number(str.charCodeAt(n)).toString(16);
		res.push(hex);
	}
	return '0x' + res.join('');
}

async function main() {
	const bytesLength = triska.data.length;
	const gameDATA = toHex(triska.data);
	console.log({
		bytesLength,
		gameDATALength: gameDATA.length
	});
	const JS24K = await ethers.getContract<JS24K>('JS24K');
	const tx = await JS24K.mint(gameDATA);
	const receipt = await tx.wait();
	console.log({gas: receipt.gasUsed.toNumber()});
	const address = (receipt as any).events[0].args[2].toHexString();
	console.log({address});

	if (address === '0x00') {
		const signers = await ethers.getUnnamedSigners();
		try {
			const tx = await signers[0].sendTransaction({
				// to: signers[1].address,
				// value: 1
				data: '0x' + '615870600E6000396158706000F3' + gameDATA.slice(2)
			});
			const receipt = await tx.wait();
			console.log({gasUsed: receipt.gasUsed.toNumber(), contractAddress: receipt.contractAddress});
		} catch (err) {
			console.error(err);
		}
	}
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
