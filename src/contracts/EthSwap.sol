// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";

contract EthSwap {
  string public name = "EthSwap Instant Exchange";
  Token public token;
  uint public rate = 100;

  event TokensPurchased(
    address account,
    address token,
    uint amount,
    uint rate
  );

    event TokensSold(
    address account,
    address token,
    uint amount,
    uint rate
  );

  constructor(Token _token) public {
    token = _token;
  }

  function buyTokens() public payable {
    // calculate number of tokens bought
    uint tokenAmount = msg.value * rate;
    // require has enough tokens
    require(token.balanceOf(address(this)) >= tokenAmount);
    // transfer to user
    token.transfer(msg.sender, tokenAmount);
    // trigger purchace event
    emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
  }

  function sellTokens(uint _amount) public  {
    // check user has enought token to sell
    require(token.balanceOf(msg.sender) >= _amount);
    // calculate ether amount to send
    uint etherAmount = _amount / rate;

    // check balance
    require(address(this).balance >= etherAmount);

    // send to swap
    token.transferFrom(msg.sender, address(this), _amount);
    // perform sale
    msg.sender.transfer(etherAmount);

    // trigger sold event
    emit TokensSold(msg.sender, address(token), _amount, rate);
    
  }
}