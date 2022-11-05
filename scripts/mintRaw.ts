// Triska game was minified using https://jsminify.org/ and an html minifier and css minifier
// encode to uri : https://base64.guru/converter/encode/html
import {ethers} from 'hardhat';
import {JS24K} from '../typechain';
import fs from 'fs';

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
	const args = process.argv.slice(2);
	const game = fs.readFileSync(args[0], {encoding: 'utf-8'});
	const gameDATA = toHex(game);

	const data = '0x' + '615870600E6000396158706000F3' + gameDATA.slice(2);
	const JS24K = await ethers.getContract<JS24K>('JS24K');
	const tx = await JS24K.mintRaw(data);
	const receipt = await tx.wait();
	console.log({gas: receipt.gasUsed.toNumber()});
	const address = (receipt as any).events[0].args[2].toHexString();
	console.log({address});
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
