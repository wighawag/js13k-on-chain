import {execute} from 'rocketh';
import 'rocketh-deploy-proxy';
import {context} from './_context';

export default execute(
	context,
	async ({deployViaProxy, accounts, artifacts}) => {
		const contract = await deployViaProxy(
			'JS24K',
			{
				account: accounts.deployer,
				artifact: artifacts.JS24K,
				args: [accounts.collectionOwner]
			},
			{
				owner: accounts.deployer,
			}
		);
	},
	{tags: ['JS24K', 'JS24K_deploy']}
);

