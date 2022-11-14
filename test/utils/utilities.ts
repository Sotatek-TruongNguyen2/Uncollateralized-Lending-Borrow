import { Contract } from 'ethers'
// import { BigNumber as BN } from 'bignumber.js'
// import {
//   BigNumber,
//   bigNumberify,
//   getAddress,
//   keccak256,
//   defaultAbiCoder,
//   toUtf8Bytes,
//   solidityPack
// } from 'ethers';
import { BigNumber } from "bignumber.js";
import { ethers, BigNumber as BigNumberV1 } from 'ethers';


export function expandTo18DecimalsV1(n: number,p = 18): any {
  return new BigNumber(n).multipliedBy(new BigNumber(10).pow(p)).toFixed()
}

export function expandTo18Decimals(n: number,p = 18): any {
  return ethers.BigNumber.from(n).mul(ethers.BigNumber.from(10).pow(p)).toString()
}

export function expandTo18DecimalsRaw(n: number,p = 18): BigNumberV1 {
  return ethers.BigNumber.from(n).mul(ethers.BigNumber.from(10).pow(p));
}