import {expect} from './chai-setup';
import {ethers, deployments, getUnnamedAccounts} from 'hardhat';
import {setupUsers} from './utils/users';
import {JS24K} from '../typechain';

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
		expect(state).to.be.not.null;
	});
});
