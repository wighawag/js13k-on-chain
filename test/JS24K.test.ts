import {expect} from './chai-setup';
import {ethers, deployments, getUnnamedAccounts} from 'hardhat';
import {setupUsers} from './utils/users';
import {JS24K} from '../typechain';
import {constants} from 'ethers';
import {toHex} from '../utils/bytes';
import triska from '../games/triska.json';

const gameDATA = toHex(triska.data);
console.log(gameDATA);

const setup = deployments.createFixture(async () => {
	await deployments.fixture('JS24K');
	const contracts = {
		JS24K: <JS24K>await ethers.getContract('JS24K')
	};
	const users = await setupUsers(await getUnnamedAccounts(), contracts);
	return {
		...contracts,
		users
	};
});

describe('JS24K', function () {
	it('works', async function () {
		const state = await setup();
		await expect(state.users[0].JS24K.mint(gameDATA))
			.to.emit(state.JS24K, 'Transfer')
			.withArgs(constants.AddressZero, state.users[0].address, '1158808384137004768675244516077074077445013636396');
	});
});
