import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
	const {deployments, getNamedAccounts} = hre;
	const {deploy} = deployments;
	const useProxy = !hre.network.live;

	const {deployer, collectionOwner} = await getNamedAccounts();

	await deploy('JS24K', {
		from: deployer,
		args: [collectionOwner],
		proxy: useProxy
			? {
					proxyContract: 'OptimizedTransparentProxy',
			  }
			: false,
		log: true,
		autoMine: true, // speed up deployment on local network (ganache, hardhat), no effect on live networks
	});
};
export default func;
func.tags = ['JS24K', 'JS24K_deploy'];
