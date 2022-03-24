// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CodeineToken is ERC20 {
    constructor() ERC20("Codeine Junk Yard", "CJY") {
        _mint(msg.sender, 1000 * 10 ** 3);
    }

      // 1000 token for an ETH
    uint256 public tokensPerEth = 1000;

    // Event for the buy operation
    event BuyTokens(address receiver, uint256 amountOfETH, uint256 amountOfTokens);

    function showBalance() public view returns (uint256){
        return this.totalSupply();
    }

    // To buy token with sender ETH
    function buyTokens() public payable returns (uint256 tokenAmount) {
        require(msg.value > 0, "Swap ETH to buy some tokens");

        uint256 amountToBuy = msg.value * tokensPerEth;

        // We check if this Contract has enough amount of tokens for transaction
        uint256 depotBalance = this.balanceOf(address(this));
        require(depotBalance >= amountToBuy, "CJY Tokens available");

        // Transfer token to the Buyer(msg.sender)
        (bool sent) = this.transfer(msg.sender, amountToBuy);
        require(sent, "Failed to transfer token to receiver");

        // emit the event
        emit BuyTokens(msg.sender, msg.value, amountToBuy);

        return amountToBuy;
    }
    
}
