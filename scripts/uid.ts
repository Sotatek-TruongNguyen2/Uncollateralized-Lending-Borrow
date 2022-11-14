import { ethers, Signer } from "ethers";

export const buildUIDIssuanceSignature = async (
    signer: Signer,
    contractAddress: string,
    account: string,
    id: number,
    expiredAt: number,
    nonce: number,
    chainId: number
): Promise<String> => {
  const msgHash = ethers.utils.keccak256(
    ethers.utils.solidityPack(
        ["address", "uint256", "uint256", "address", "uint256", "uint256"],
        [
            account,
            id,
            expiredAt,
            contractAddress,
            nonce,
            chainId
        ]
    )
  );

  return await signer.signMessage(
    ethers.utils.arrayify(msgHash)
  );
}