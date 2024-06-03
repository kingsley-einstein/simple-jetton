import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { SimpleJetton } from '../wrappers/SimpleJetton';
import '@ton/test-utils';

describe('SimpleJetton', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let simpleJetton: SandboxContract<SimpleJetton>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        simpleJetton = blockchain.openContract(await SimpleJetton.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await simpleJetton.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            },
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: simpleJetton.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and simpleJetton are ready to use
    });
});
