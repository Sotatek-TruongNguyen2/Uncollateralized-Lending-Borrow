import { ethers, Signer } from "ethers";

export const buildDepositSignature = async (
    signer: Signer,
    contractAddress: string,
    spender: string,
    value: string,
    deadline: string,
    nonce: string,
) => {
  const signature = await (signer as any)._signTypedData(
      // domain
      {
        name: "USDC",
        version: "2",
        chainId: "31337",
        verifyingContract: contractAddress,
      },
      {
        Permit: [
          { name: 'owner', type: 'address' },
          { name: 'spender', type: 'address' },
          { name: 'value', type: 'uint256' },
          { name: 'nonce', type: 'uint256' },
          { name: 'deadline', type: 'uint256' }
        ]
      },
      {
        owner: await signer.getAddress(),
        spender,
        value,
        nonce,
        deadline
      }
  );

  return {
    ...ethers.utils.splitSignature(signature)
  };
}