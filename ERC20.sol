// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./CodeineToken.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

//ownership of the contract
contract SellToken is Ownable {

  // Token Contract initialization
  CodeineToken mainCT;

  // 1000 token for an ETH
  uint256 public tokensPerEth = 1000;

  // Event for the buy operation
  event BuyTokens(address receiver, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    mainCT = CodeineToken(tokenAddress);
  }

  // To buy token with sender ETH
  function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Swap ETH to buy some tokens");

    uint256 amountToBuy = msg.value * tokensPerEth;

    // We check if this Contract has enough amount of tokens for transaction
    uint256 depotBalance = mainCT.balanceOf(address(this));
    require(depotBalance >= amountToBuy, "CJY Tokens available");

    // Transfer token to the Buyer(msg.sender)
    (bool sent) = mainCT.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to receiver");

    // emit the event
    emit BuyTokens(msg.sender, msg.value, amountToBuy);

    return amountToBuy;
  }

  // To make this Conract have the power to withdraw ETH used for purchase into our ETH address
  function withdraw() public onlyOwner {
    uint256 ownerBalance = address(this).balance;
    require(ownerBalance > 0, "Owner has not balance to withdraw");

    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send user balance back to the owner");
  }
}
