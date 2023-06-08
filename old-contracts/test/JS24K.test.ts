import {expect} from './chai-setup';
import {ethers, deployments, getUnnamedAccounts} from 'hardhat';
import {setupUsers} from './utils/users';
import {JS24K} from '../typechain';
import {BigNumber, constants} from 'ethers';
import {toHex} from '../utils/bytes';
import triska from '../games/triska.json';
import k24 from '../games/limit_24576.json';
import greaterThank24 from '../games/greater_than_24576.json';
import {computeNextContractAddress} from '../utils/ethereum';

const gameDATA = toHex(triska.data);

const setup = deployments.createFixture(async () => {
	await deployments.fixture('JS24K');
	const contracts = {
		JS24K: <JS24K>await ethers.getContract('JS24K'),
	};
	const users = await setupUsers(await getUnnamedAccounts(), contracts);
	return {
		...contracts,
		users,
	};
});

describe('JS24K', function () {
	it('works', async function () {
		const state = await setup();
		const expectedAddress = await computeNextContractAddress(state.JS24K);
		await expect(state.users[0].JS24K.mint(gameDATA))
			.to.emit(state.JS24K, 'Transfer')
			.withArgs(constants.AddressZero, state.users[0].address, BigNumber.from(expectedAddress));
	});

	it('works with 24k', async function () {
		const state = await setup();
		const expectedAddress = await computeNextContractAddress(state.JS24K);
		const hexData = toHex(k24.data);
		await expect(state.users[0].JS24K.mint(hexData))
			.to.emit(state.JS24K, 'Transfer')
			.withArgs(constants.AddressZero, state.users[0].address, BigNumber.from(expectedAddress));
	});

	it('does not works with greater 24k', async function () {
		const state = await setup();
		const bytecode = toHex(greaterThank24.data);
		console.log({length: (bytecode.length - 2) / 2});
		await expect(state.users[0].JS24K.mint(bytecode)).to.be.revertedWith('too big');
	});
});
