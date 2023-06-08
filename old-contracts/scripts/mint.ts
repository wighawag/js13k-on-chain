// Triska game was minified using https://jsminify.org/ and an html minifier and css minifier
// encode to uri : https://base64.guru/converter/encode/html
import {ethers} from 'hardhat';
import {JS24K} from '../typechain';
import fs from 'fs';

async function main() {
	const args = process.argv.slice(2);
	const gameDATA = '0x' + fs.readFileSync(args[0]).toString('hex');
	console.log({
		numBytes: (gameDATA.length - 2) / 2,
	});
	const JS24K = await ethers.getContract<JS24K>('JS24K');
	const tx = await JS24K.mint(gameDATA);
	const receipt = await tx.wait();
	console.log({gas: receipt.gasUsed.toNumber()});
	console.log(JSON.stringify(receipt.logs, null, 2));
	const address = ((receipt as any).events[1] || (receipt as any).events[0]).args[2].toHexString();
	console.log({address});

	if (address == '0x00') {
		// const tx2 = await JS24K.debug(gameDATA);
		// const receipt2 = await tx2.wait();
		// console.log({gas: receipt2.gasUsed.toNumber()});
		// console.log(JSON.stringify(receipt2.logs, null, 2));
	}

	if (address == '0x00') {
		const signers = await ethers.getUnnamedSigners();
		try {
			const data = '0x' + '615870600E6000396158706000F3' + gameDATA.slice(2);
			// console.log(JSON.stringify({data}, null, 2));
			const tx = await signers[0].sendTransaction({
				// to: signers[1].address,
				// value: 1
				data,
			});
			const receipt = await tx.wait();
			console.log('FAILED, fallback on manual', {
				gasUsed: receipt.gasUsed.toNumber(),
				contractAddress: receipt.contractAddress,
			});
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
