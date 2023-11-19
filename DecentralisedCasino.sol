// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract DecentralisedCasino {
    mapping(address => uint256) blockNumbersToBeUsed;
    mapping(address => uint256) gameEthValues;

    function fundBank() external payable {}

    function playGame() external payable {
        uint256 blockNumberToBeUsed = blockNumbersToBeUsed[msg.sender];

        // when the player plays for the very first time, it determines the future block number
        if (blockNumberToBeUsed == 0) {
            blockNumbersToBeUsed[msg.sender] = block.number + 2;
            gameEthValues[msg.sender] = msg.value;
            return;
        }

        require(block.number >= blockNumberToBeUsed, "DeCasino: Too early");
        uint256 randomNumber = block.prevrandao;

        if (randomNumber % 2 == 0) {
            uint256 winningAmount = gameEthValues[msg.sender] * 2;
            (bool success, ) = msg.sender.call{value: winningAmount}("");
            require(success, "Transfer failed");
        }

        blockNumbersToBeUsed[msg.sender] = 0;
        gameEthValues[msg.sender] = 0;
    }
}
